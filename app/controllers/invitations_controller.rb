class InvitationsController < ApplicationController
  before_action :authenticate_user!, only: [:cancel]

  rescue_from ActiveRecord::RecordNotFound, :with => :invitation_not_found
  rescue_from Invitation::InvitationAlreadyAccepted, :with => :invitation_not_found

  def create
    @party = Party.friendly.find(params[:party_id])
    @invitation = @party.invitations.build(invitation_params)
    @invitation.intent = 'to_join_party'
    @invitation.inviter = current_user
    authorize(@invitation)
    if @invitation.save
      flash[:notice] = "Invited #{@invitation.name} to #{@invitation.invitable.name}."
    else
      flash[:error] = "Could not send invitation. See errors below."
      return render 'parties/show'
    end
    redirect_to party_path(@party)
  end

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
    flash[:notice] = "Cancelled invitation to #{invitation.name}."
    redirect_to(party_path(invitation.invitable))
  end

  private
    def invitation
      @invitation ||= Invitation.find_by!(token: params[:id])
    end

    def invitation_not_found
      render 'invitation_not_found'
    end

    def invitation_params
      params.require(:invitation).permit(:name, :email)
    end
end
