class InvitationsController < ApplicationController
  before_action :authenticate_user!, only: [:cancel]

  rescue_from ActiveRecord::RecordNotFound, :with => :invitation_not_found
  rescue_from Invitation::InvitationAlreadyAccepted, :with => :invitation_not_found

  def show
    authorize(invitation)
    raise Invitation::InvitationAlreadyAccepted if invitation.accepted?

    if current_user
      session.delete(:invitation_token)
      invitation.accept!(current_user)
      redirect_to(walkthrough_party_path(invitation.invitable))
    else
      session[:invitation_token] = invitation.token
      redirect_to(new_user_registration_path)
    end
  end

  def destroy
    authorize(invitation)
    invitation.destroy
    flash[:notice] = 'Invitation cancelled.'
    redirect_to(invited_reps_party_path(@invitation.invitable))
  end

  private
    def invitation
      @invitation ||= Invitation.find_by!(token: params[:id])
    end

    def invitation_not_found
      render 'invitation_not_found'
    end
end
