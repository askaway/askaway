class AnswerPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def create?
    user.is_rep? && !party_has_already_answered?
  end

  private

  def party_has_already_answered?
    QuestionQueries.has_answer_from_party?(@record.question, user.rep.party)
  end
end
