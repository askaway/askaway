class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: :show

  def show
    authorize @user
  end

  def update
    authorize current_user
    if current_user.update(user_params)
      flash[:notice] = 'Your profile has been updated.'
      redirect_to root_url
    else
      flash[:notice] = 'Could not update your profile.'
      @user = current_user
      render 'edit'
    end
  end

  def edit
    authorize current_user
    @user = current_user
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
    unless params[:user]
      flash[:alert] = 'Oops! Looks like you forgot to choose a picture to upload.'
      return render 'new_avatar'
    end
    current_user.uploaded_avatar = params[:user][:uploaded_avatar]
    if current_user.valid?
      current_user.select_avatar!(type: 'uploaded_avatar')
      flash[:notice] = 'Lookin good! Profile picture updated.'
      redirect_to edit_users_path
    else
      flash[:alert] = "Oops! We couldn't update your picture for some reason."
      render 'new_avatar'
    end
  end

  def select_avatar
    authorize current_user
    identity, type = params[:identity], params[:type]
    if current_user.select_avatar!(identity_id: identity, type: type)
      flash[:notice] = 'Lookin good! Profile picture updated.'
    else
      flash[:notice] = "Oops! We couldn't update your picture for some reason."
    end
    redirect_to edit_users_path
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end
end
