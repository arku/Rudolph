class PeopleController < ApplicationController
  layout 'application'

  before_action :authenticate_person!

  def update
    if current_person.id == params[:id].to_i
      begin
        current_person.update!(person_params)
        flash.notice = 'Successfully updated your information'
      rescue => error
        flash.alert = error.message
      end
    else
      flash.alert = 'Invalid user'
    end

    redirect_to edit_person_registration_path
  end

  def person_params
    params.require(:person).permit(:name, :image, :email)
  end

end