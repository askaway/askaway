class VotePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def destroy?
    if user
      user.id == @record.user_id
    else
      !@record.user_id
    end
  end
end
