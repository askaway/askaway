class QuestionVoter
  def initialize(question, user)
    @question = question
    @user = user
  end

  def execute!
    Vote.create!(question: @question, user: @user)
  end
end
