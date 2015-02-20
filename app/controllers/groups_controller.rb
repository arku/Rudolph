class GroupsController < ApplicationController
  layout 'application'

  before_action :authenticate_person!

  def index
  end

end