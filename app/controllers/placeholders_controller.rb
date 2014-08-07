class PlaceholdersController < ApplicationController
  def new
    @placeholder = Placeholder.new
    authorize @placeholder
  end

  def create
    @resource = Placeholder.new
    authorize @resource
    perform_avatar_upload(path_for_redirect: root_path)
  end

  def new_avatar
    @resource = placeholder
    authorize @resource
    @title = "Replace placeholder picture"
    render 'users/new_avatar'
  end

  def upload_avatar
    @resource = placeholder
    authorize @resource
    perform_avatar_upload(path_for_redirect: placeholder_path(placeholder))
  end

  def show
    authorize placeholder
  end

  private
    def placeholder
      @placeholder ||= Placeholder.find(params[:id])
    end
end
