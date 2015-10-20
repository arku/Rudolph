class GroupsController < ApplicationController
  layout 'application'

  before_action :authenticate_person!
  before_action :validate_group_person, except: [:index, :new, :create]

  before_filter :initialize_group
  before_filter :initialize_breadcrumbs, only: [:show, :new, :edit, :who, :edit_wishlist, :wishlists, :activity]

  def initialize_group
    @group = params[:id].present? ? Group.find(params[:id]) : Group.new
    @group_service = GroupService.new(@group, current_person)
  end

  def initialize_breadcrumbs
    add_breadcrumb t('my_groups'), :root_path
  end

  def validate_group_person
    redirect_to root_path unless current_person.is_member?(Group.find(params[:id]))
  end

  def index
    @groups   = current_person.groups
    @activity = GroupActivity.by_person(current_person)
  end

  def show
    @draw_pending         = @group.draw_pending?
    @is_admin             = current_person.is_admin?(@group)
    @wishlist_description = current_person.wishlist_description(@group)
    all_items             = current_person.wishlist_items(@group)
    @wishlist_size        = all_items.size
    @wishlist_items       = all_items.limit(3)
    @activity             = @group.group_activities.limit(3)

    add_breadcrumb @group.name
  end

  def new
    add_breadcrumb t('new_group_title')
  end

  def create
    response = @group_service.create_group(group_params)

    if response[:success]
      flash.notice = response[:message]
      redirect_to group_path(@group_service.group)
    else
      flash.alert = response[:message]
      render 'new'
    end
  end

  def edit
    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb t('edit')
  end

  def update
    response = @group_service.update_group(group_params)

    if response[:success]
      flash.notice = response[:message]
      redirect_to group_path(@group)
    else
      flash.alert = response[:message]
      render 'edit'
    end
  end

  def draw
    response = @group_service.draw_names
    @success = response[:success]
  end

  def who
    @person = Exchange.where(group: @group, giver: current_person).first.try(:receiver)
    @wishlist_items = @person.wishlist_items(@group)
    @wishlist_description = @person.wishlist_description(@group)

    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb t('result')
  end

  def send_invitations
    response = @group_service.send_invitations(params[:friends])
    @success = response[:success_list]
    @errors = response[:error_list]

    @is_admin = current_person.is_admin?(@group)
    @draw_pending = @group.draw_pending?
  end

  def remove_member
    @person = Person.find(params[:member_id])
    @success = @group_service.remove_member(@person)
  end

  def make_admin
    response = @group_service.make_admin(params[:member_id])
    response[:success] ? flash.notice = response[:message] : flash.alert = response[:message]
    redirect_to group_path(params[:id])
  end

  def accept_group
    response = @group_service.accept_group
    response[:success] ? flash.notice = response[:message] : flash.alert = response[:message]
    redirect_to group_path(params[:id])
  end

  def leave_group
    response = @group_service.remove_member(current_person)

    if response[:success]
      flash.notice = t('left_group')
      redirect_to root_path
    else
      flash.alert = t('didnt_leave')
      redirect_to group_path(@group_service.group)
    end
  end

  def edit_wishlist
    group_person = current_person.group_person(@group)
    @wishlist_items = group_person.wishlist_items
    @description    = group_person.wishlist_description

    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb t('wishlist')
  end

  def update_wishlist
    wishlist_service = WishlistService.new(@group, current_person)
    response = wishlist_service.update(params[:wishlist_description], params[:items])

    if response[:success]
      flash.notice = response[:message]
    else
      flash.alert = response[:message]
    end

    redirect_to edit_wishlist_group_path
  end

  def remove_from_wishlist
    wishlist_service = WishlistService.new(@group, current_person)
    response = wishlist_service.remove_item(params[:item_id])

    if response[:success]
      flash.notice = response[:message]
    else
      flash.alert = response[:message]
    end

    redirect_to edit_wishlist_group_path
  end

  def wishlists
    @person = Person.find(params[:person_id])
    @wishlist_items = @person.wishlist_items(@group)
    @wishlist_description = @person.wishlist_description(@group)

    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb t('persons_wishlist', name: @person.first_name)
  end

  def activity
    @activity = @group.group_activities

    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb t('group_activity')
  end

  def message_board
    @messages = @group.public_messages

    add_breadcrumb @group.name, group_path(@group)
    add_breadcrumb t('message_board')
  end

  def send_message
    @message = Message.create!(group: @group, sender: current_person, message: params[:message])
  end

  def get_coordinates
    render json: {latitude: @group.latitude, longitude: @group.longitude}.to_json
  end

  private

  def group_params
    params.require(:group).permit(:admin_id, :name, :description, :location, :date, :price_range)
  end

end