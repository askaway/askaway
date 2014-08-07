class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    authorize user
    redirect_to_canonical_show_path(user)
    @profile = ProfilePresenter.new(current_user, user)

    @meta_title = "#{user.name} | #{@meta_title}"
    @meta_description = "#{user.name} on Ask Away - a place to ask NZ's parties questions and see their answers."
    @meta_img = URI(request.url) + user.avatar_url(size: :large)
  end

  def update
    authorize user
    if user.update(user_params)
      flash[:notice] = 'Your profile has been updated.'
      redirect_to root_url
    else
      flash[:notice] = 'Could not update your profile.'
      render 'edit'
    end
  end

  def edit
    authorize user
    @title_change_picture = 'Choose a profile picture'
    @title_change_picture += " for #{user.name}" if user != current_user
    @title_edit_details = 'Edit your details'
    @title_edit_details = "Edit #{user.name}'s details" if user != current_user
  end

  def finish_signup
    authorize user
    if request.patch? && params[:user]
      if user.update(user_params)
        sign_in(user, :bypass => true)
        redirect_path = session[:previous_url] || root_path
        if user.is_rep?
          redirect_path = walkthrough_party_path(user.party)
        end
        redirect_to redirect_path
      else
        @show_errors = true
      end
    end
  end

  def new_avatar
    authorize user
    @resource = user
    @title = 'Upload a profile picture'
    @title += " for #{user.name}" if user != current_user
  end

  def upload_avatar
    authorize user
    @resource = user
    perform_avatar_upload(path_for_redirect: edit_user_path(user))
  end

  def select_avatar
    authorize user
    identity, type = params[:identity], params[:type]
    if user.select_avatar!(identity_id: identity, type: type)
      flash[:notice] = 'Lookin good! Profile picture updated.'
    else
      flash[:notice] = "Oops! We couldn't update your picture for some reason."
    end
    redirect_to edit_user_path(user)
  end

  private
    def user
      @user ||= User.friendly.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
