class PartyPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def new_reps?
    user && (user.is_admin? || user_is_party_rep?)
  end

  def invite_reps?
    new_reps?
  end

  def invited_reps?
    new_reps?
  end

  def walkthrough?
    new_reps?
  end

  private

  def user_is_party_rep?
    @record.rep_users.exists?(id: user.id)
  end
end
