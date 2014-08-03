class PartyPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def invite_reps?
    user.can_administer?(@record)
  end

  def walkthrough?
    user.can_administer?(@record)
  end

  def new_avatar?
    user.can_administer?(@record)
  end

  def upload_avatar?
    user.can_administer?(@record)
  end
end
