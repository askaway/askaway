class UserPolicy

  attr_reader :user, :current_user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def edit?
    @current_user == @user
  end

  def update?
    edit?
  end
end
