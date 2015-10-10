class PeopleController < ApplicationController
  layout 'application'

  before_action :authenticate_person!, except: :change_locale

  def index
    redirect_to root_path
  end

  def update
    if current_person.id == params[:id].to_i
      begin
        current_person.update!(person_params)
        flash.notice = t('updated_information')
      rescue => error
        flash.alert = error.message
      end
    else
      flash.alert = t('invalid_user')
    end

    redirect_to edit_person_registration_path
  end

  def destroy
    person = Person.find(params[:id])
    groups = person.is_admin_of

    if groups.any?
      flash.alert = t('cant_remove_admin', group_list: groups.map{|g| g.name}.join(', '))
      redirect_to :back
    else
      begin
        person.destroy!
        flash.notice = t('account_deleted')
        redirect_to root_path
      rescue => error
        flash.alert = error.message
      end
    end
  end

  def change_locale
    locale = params[:locale]

    if ['en', 'pt-br'].include?(locale)
      if current_person
        current_person.update_attribute(:locale, locale)
      else
        I18n.locale = locale
        session[:locale] = locale
      end
    end

    redirect_to :back
  end

  def person_params
    params.require(:person).permit(:name, :image, :email, :password, :password_confirmation)
  end

end