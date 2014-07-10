class PartiesController < ApplicationController
  before_filter :fetch_party_and_authorize

  def show
    @invitation = Invitation.new
    if request.path != party_path(@party)
      redirect_to @party, status: :moved_permanently
    end
  end

  def walkthrough; end

  private

  def fetch_party_and_authorize
    @party ||= Party.friendly.find(params[:id])
    authorize @party
  end
end
