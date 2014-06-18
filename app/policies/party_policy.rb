class PartyPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def new_members?
    user && (user.is_admin? || user_is_member?)
  end

  def invite_members?
    new_members?
  end

  def invited_members?
    new_members?
  end

  def walkthrough?
    new_members?
  end

  private

  def user_is_member?
    @record.members.exists?(id: user.id)
  end
end
