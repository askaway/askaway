class InvitationsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :invitation_not_found
  rescue_from Invitation::InvitationAlreadyAccepted, :with => :invitation_not_found

  def show
    if invitation.accepted?
      raise Invitation::InvitationAlreadyAccepted
    end

    if current_user
      session.delete(:invitation_token)
      if invitation.accept!(current_user)
        redirect_to(walkthrough_party_path(invitation.invitable))
      else
        flash[:alert] = "Could not accept invitation. You might already be a member of #{invitation.invitable.name}."
        redirect_to(root_path)
      end
    else
      session[:invitation_token] = invitation.token
      redirect_to(new_user_registration_path)
    end
  end

  private

  def invitation
    @invitation ||= Invitation.find_by!(token: params[:id])
  end

  def invitation_not_found
    render 'invitation_not_found'
  end
end
