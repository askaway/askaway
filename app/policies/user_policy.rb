class UserPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def finish_signup?
    true
  end

  def update?
    true
  end

  def edit?
    true
  end

  def new_avatar?
    user.is_rep? || user.is_admin?
  end

  def upload_avatar?
    user.is_rep? || user.is_admin?
  end

  def select_avatar?
    true
  end
end
