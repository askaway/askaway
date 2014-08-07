class PartiesController < ApplicationController
  before_filter :fetch_party_and_authorize

  def show
    @profile = ProfilePresenter.new(current_user, @party)
    @invitation = Invitation.new
    redirect_to_canonical_show_path(@party)

    @meta_title = "#{@party.name} - Answering your questions on Ask Away"
    @meta_description = "Ask the #{@party.name} questions and see their answers this New Zealand election."
    @meta_img = URI(request.url) + @party.avatar_url(size: :large)
  end

  def walkthrough; end

  def new_avatar
    @resource = @party
    @title = "Upload a profile picture for #{@party.name}"
    render 'users/new_avatar'
  end

  def upload_avatar
    @resource = @party
    perform_avatar_upload(path_for_redirect: party_path(@party))
  end

  private
    def fetch_party_and_authorize
      @party ||= Party.friendly.find(params[:id])
      authorize @party
    end
end
