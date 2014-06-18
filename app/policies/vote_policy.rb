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
    user.id == @record.user_id unless user.nil?
  end
end
