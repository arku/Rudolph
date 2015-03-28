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

  private

  def group_params
    params.require(:group).permit(:admin_id, :name, :description, :location, :date, :price_range)
  end

end