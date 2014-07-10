class InvitationPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def destroy?
    user.is_rep_for?(@record.invitable) || user.is_admin?
  end
end
