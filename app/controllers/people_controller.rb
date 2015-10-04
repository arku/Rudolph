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

  def destroy
    person = Person.find(params[:id])
    groups = person.is_admin_of

    if groups.any?
      flash.alert = "You are the admin of the following groups: #{groups.map{|g| g.name}.join(', ')}. Please name someone else admin before you cancel your account."
      redirect_to :back
    else
      begin
        person.destroy!
        flash.notice = 'Account deleted. Hope to see you again soon!'
        redirect_to root_path
      rescue => error
        flash.alert = error.message
      end
    end
  end

  def change_locale
    locale = params[:locale]
    current_person.update_attribute(:locale, locale) if ['en', 'pt-br'].include?(locale)
    redirect_to :back
  end

  def person_params
    params.require(:person).permit(:name, :image, :email)
  end

end