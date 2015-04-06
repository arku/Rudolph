class IndexController < ApplicationController
  layout 'application'

  def index
    redirect_to groups_path if current_person
  end

end