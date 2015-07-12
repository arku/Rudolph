require File.join(Rails.root, 'app/business/name_drawer')

class GroupsController < ApplicationController
  layout 'application'

  before_action :authenticate_person!
  before_action :validate_group_person, except: [:index, :new, :create]

  def validate_group_person
    redirect_to root_path unless current_person.is_member?(Group.find(params[:id]))
  end

  def index
    @groups = current_person.groups
  end

  def show
    @group = Group.find(params[:id])
    @draw_pending = @group.draw_pending?
    @is_admin = current_person.is_admin?(@group)
  end

  def new
    @group = Group.new
  end

  def create
    group_data = group_params
    group_data[:date] = Date.strptime(group_params[:date], '%m/%d/%Y')

    @group = Group.new(group_data)

    if @group.save
      flash.notice = "Successfully created group #{@group.name}"
      redirect_to group_path(@group)
    else
      flash.alert = e.message
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    begin
      @group.update!(group_params)
      flash.notice = "Successfully updated group #{@group.name}"
      redirect_to group_path(@group)
    rescue => error
      flash.alert = error.message
      render 'edit'
    end
  end

  def draw
    group = Group.find(params[:id])
    @success = NameDrawer.new(group).perform
  end

  def who
    group = Group.find(params[:id])
    @person = Exchange.where(group: group, giver: current_person).first.try(:receiver)
  end

  def send_invitations
    @errors = {}
    @success = []
    @group = Group.find(params[:id])

    params[:friends].each do |email|
      person = Person.where(email: email).first

      if !person || person.can_be_invited?
        person = Person.invite!(email: email, invited_by_id: current_person.id)

        if person.valid?
          group_person = GroupPerson.create(group_id: params[:id], person_id: person.id)

          group_person.valid? ? @success << email :  @errors[email] = group_person.error_messages
        else
          @errors[email] = person.error_messages
        end
      end
    end
  end

  def remove_member
    group = Group.find(params[:id])
    @person = Person.find(params[:member_id])

    if current_person.is_admin?(group) && group.draw_pending?
      @success = GroupPerson.where(group_id: group.id, person_id: @person.id).first.try(:destroy)
    end
  end

  def make_admin
    group = Group.find(params[:id])

    if current_person.is_admin?(group)
      begin
        group.admin = Person.find(params[:member_id])
        group.save!
        flash.notice = 'Admin updated successfully'
      rescue => error
        flash.alert = error.message
      end
    else
      flash.alert = 'Only the Admin can make someone else Admin'
    end

    redirect_to group_path(group)
  end

  private

  def group_params
    params.require(:group).permit(:admin_id, :name, :description, :location, :date, :price_range)
  end

end