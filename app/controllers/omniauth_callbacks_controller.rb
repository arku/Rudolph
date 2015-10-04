class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    auth = request.env["omniauth.auth"]
    invitation_token = session[:invitation_token]

    if invitation_token
      person = Person.find_by_invitation_token(invitation_token, true)
      person.apply_omniauth(auth)
      session[:invitation_token] = nil
    else
      begin
        if current_person
          person = current_person
          person.apply_omniauth(auth)
          sign_out
        else
          person = Person.omniauth(auth)
        end
      rescue => error
        flash.alert = error.message
        redirect_to :back and return
      end
    end

    if person.persisted?
      person.accept_invitation! if person.invited?
      sign_in(:person, person)
      flash.notice = t('signed_in_with_provider', provider: auth.provider)
    else
      session["devise.user_attributes"] = person.attributes
    end

    redirect_to after_sign_in_path_for(person)
  end

  alias_method :facebook, :all

  def failure
    redirect_to root_path
  end

  def params
    params.require(:person).permit(:provider, :uid, :name, :image, :token, :expires_at)
  end
end