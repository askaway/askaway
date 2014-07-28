class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: :show

  def show
    authorize @user
  end

  def update
    authorize current_user
    current_user.update(user_params)
    flash[:notice] = 'Your profile has been updated.'
    redirect_to root_url
  end

  def edit
    authorize current_user
  end

  def finish_signup
    authorize current_user
    if request.patch? && params[:user]
      if current_user.update(user_params)
        sign_in(current_user, :bypass => true)
        redirect_path = session[:previous_url] || root_path
        if current_user.is_rep?
          redirect_path = walkthrough_party_path(current_user.party)
        end
        redirect_to redirect_path
      else
        @show_errors = true
      end
    end
  end

  def new_avatar
    authorize current_user
  end

  def upload_avatar
    authorize current_user
    current_user.uploaded_avatar = params[:user][:uploaded_avatar]
    current_user.save!
    flash[:notice] = 'Profile picture updated.'
    redirect_to edit_user_path(current_user)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
