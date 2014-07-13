class AnswerPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def create?
    user.is_rep?
  end

  def edit?
    user && (user.is_rep_for?(@record.rep.party) || user.is_admin?)
  end

  def update?
    edit?
  end

  def history?
    true
  end
end
