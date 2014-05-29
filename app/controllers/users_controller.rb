class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  def update
    current_user.update_attributes(params.require(:user).permit(:name, :email))
    flash[:notice] = 'Your profile has been updated.'
    redirect_to root_url
  end
end
