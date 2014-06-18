class PartiesController < ApplicationController
  before_filter :fetch_party_and_authorize
  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def show; end

  def new_members
    @invite_members_form = InviteMembersForm.new
  end

  def invite_members
    if Invitation.batch_invite!(emails: params[:invite_members_form][:emails],
                          intent: 'to_join_party',
                          invitable: @party,
                          inviter: current_user)
      flash[:notice] = 'Members invited.'
    else
      flash[:alert] = 'Members could not be invited.'
    end
    redirect_to party_path(@party)
  end

  def invited_members; end

  def walkthrough; end

  private

  def fetch_party_and_authorize
    @party ||= Party.find(params[:id])
    authorize @party
  end
end
