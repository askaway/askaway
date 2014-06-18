class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    authorize current_user
    current_user.update_attributes(params.require(:user).permit(:name, :email))
    flash[:notice] = 'Your profile has been updated.'
    redirect_to root_url
  end

  def edit
    authorize current_user
  end
end
