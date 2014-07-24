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
end
