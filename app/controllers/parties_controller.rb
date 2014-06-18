class PartiesController < ApplicationController
  before_filter :fetch_party_and_authorize
  after_action :verify_authorized, :except => :index
  after_action :verify_policy_scoped, :only => :index

  def show; end

  def new_reps
    @invite_reps_form = InviteRepsForm.new
  end

  def invite_reps
    if Invitation.batch_invite!(emails: params[:invite_reps_form][:emails],
                          intent: 'to_join_party',
                          invitable: @party,
                          inviter: current_user)
      flash[:notice] = 'Reps invited.'
    else
      flash[:alert] = 'Reps could not be invited.'
    end
    redirect_to party_path(@party)
  end

  def invited_reps; end

  def walkthrough; end

  private

  def fetch_party_and_authorize
    @party ||= Party.find(params[:id])
    authorize @party
  end
end
