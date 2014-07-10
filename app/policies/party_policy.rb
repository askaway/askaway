class PartyPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def invite_reps?
    user && (user.is_admin? || user_is_party_rep?)
  end

  def walkthrough?
    invite_reps?
  end

  private

  def user_is_party_rep?
    @record.rep_users.exists?(id: user.id)
  end
end
