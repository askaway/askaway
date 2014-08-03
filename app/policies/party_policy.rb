class PartyPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def invite_reps?
    user_can_administer_party?
  end

  def walkthrough?
    user_can_administer_party?
  end

  def new_avatar?
    user_can_administer_party?
  end

  def upload_avatar?
    user_can_administer_party?
  end

  private
    def user_can_administer_party?
      user.try(:can_administer?, @record)
    end
end
