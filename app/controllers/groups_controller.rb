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
      flash[:success] = "Successfully created group #{@group.name}"
      redirect_to group_path(@group)
    else
      flash[:error] = e.message
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      flash[:success] = "Successfully updated group #{@group.name}"
      redirect_to group_path(@group)
    else
      flash[:error] = e.message
      render 'edit'
    end
  end

  def draw
  end

  def send_invitations
    @errors = {}
    @success = []

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

  private

  def group_params
    params.require(:group).permit(:admin_id, :name, :description, :location, :date, :price_range)
  end

end