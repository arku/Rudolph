class InvitationsController < Devise::InvitationsController

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    invitation_token = params[:invitation_token]

    if invitation_token && self.resource = resource_class.find_by_invitation_token(invitation_token, true)
      session[:invitation_token] = invitation_token
      render :edit
    else
      set_flash_message(:alert, :invitation_token_invalid)
      redirect_to after_sign_out_path_for(resource_name)
    end
  end

  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(person_params)

    if resource.errors.empty?
      session[:invitation_token] = nil
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource){ render :edit }
    end
  end

  def person_params
    params.require(:person).permit(:invitation_token, :password, :password_confirmation, :name)
  end

end