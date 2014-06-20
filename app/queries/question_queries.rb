class QuestionQueries
  class << self
    def has_answer_from_party?(question, party)
      question.answers.joins(:rep).where("reps.party_id = ?", party.id).exists?
    end
  end
end
