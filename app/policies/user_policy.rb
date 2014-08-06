class UserPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def edit?
    user.is_admin? || (user == @record)
  end

  def update?
    edit?
  end

  def select_avatar?
    edit?
  end

  def upload_avatar?
    user.is_admin? || (user.is_rep? && (user == @record))
  end

  def new_avatar?
    upload_avatar?
  end

  def finish_signup?
    user == @record
  end
end
