class PartiesController < ApplicationController
  before_filter :fetch_party_and_authorize

  def show
    @invitation = Invitation.new
    if request.path != party_path(@party)
      redirect_to @party, status: :moved_permanently
    end
  end

  def walkthrough; end

  def new_avatar
    @resource = @party
    @title = "Upload a profile picture for #{@party.name}"
    render 'users/new_avatar'
  end

  def upload_avatar
    authorize current_user
    @resource = @party
    perform_avatar_upload(@party, party_path(@party))
  end

  private
    def fetch_party_and_authorize
      @party ||= Party.friendly.find(params[:id])
      authorize @party
    end
end
