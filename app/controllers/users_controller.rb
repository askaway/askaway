class UsersController < ApplicationController
  before_filter :fetch_and_authorize_user, only: [:update, :edit]

  def update
    @user.update_attributes(params.require(:user).permit(:name, :email))
    flash[:notice] = 'Your profile has been updated.'
    redirect_to root_url
  end

  private

  def fetch_and_authorize_user
    @user ||= current_user
    authorize(@user)
  end
end
