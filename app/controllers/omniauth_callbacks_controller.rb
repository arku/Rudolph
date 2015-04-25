class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    auth = request.env["omniauth.auth"]
    invitation_token = session[:invitation_token]

    if invitation_token
      person = Person.find_by_invitation_token(invitation_token, true)
      person.apply_omniauth(auth)
      session[:invitation_token] = nil
    else
      person = Person.omniauth(auth)
    end

    if person.persisted?
      person.accept_invitation! if person.invited?
      sign_in(:person, person)
      flash.notice = "Successfully signed in via #{auth.provider}!"
    else
      session["devise.user_attributes"] = person.attributes
    end

    redirect_to root_path
  end

  alias_method :facebook, :all

  def params
    params.require(:person).permit(:provider, :uid, :name, :image, :token, :expires_at)
  end
end