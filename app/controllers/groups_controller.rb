class GroupsController < ApplicationController
  layout 'application'

  before_action :authenticate_person!

  def index
    @groups = current_person.groups
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      flash[:success] = "Successfully created group #{@group.name}"
      redirect_to groups_path
    else
      flash[:error] = e.message
      render 'new'
    end
  end

  def send_invitations
    @errors = {}
    @success = []

    params[:friends].each do |email|
      person = Person.invite!(email: email, invited_by_id: current_person.id)

      if person.valid?
        group_person = GroupPerson.create(group_id: params[:group_id], person_id: person.id)
        
        group_person.valid? ? @success << email :  @errors[email] = group_person.error_messages
      else
        @errors[email] = person.error_messages
      end
    end
  end

  private

  def group_params
    params.require(:group).permit(:admin_id, :name, :description, :location, :date, :price_range)
  end

end