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
    # change
    unless params[:party]
      flash[:alert] = 'Oops! Looks like you forgot to choose a picture to upload.'
      return render 'new_avatar'
    end
    # change
    @resource.uploaded_avatar = params[:party][:uploaded_avatar]
    if @resource.valid?
      @resource.select_avatar!(type: 'uploaded_avatar')
      flash[:notice] = 'Lookin good! Profile picture updated.'
      # change
      redirect_to party_path(@party)
    else
      flash[:alert] = "Oops! We couldn't update your picture. Make sure it's under 5 megabytes."
      render 'new_avatar'
    end
  end

  private
    def fetch_party_and_authorize
      @party ||= Party.friendly.find(params[:id])
      authorize @party
    end
end
