class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = Person.omniauth(request.env["omniauth.auth"])
    
    if user.persisted?
      sign_in(:person, user)
      flash.notice = "Successfully signed in via #{request.env["omniauth.auth"].provider}!"
      redirect_to root_path
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to root_path
    end
  end

  alias_method :facebook, :all

  def params
    params.require(:person).permit(:provider, :uid, :name, :image, :token, :expires_at)
  end
end