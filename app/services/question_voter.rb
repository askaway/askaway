class QuestionVoter
  def initialize(question, user, ip_address)
    @question = question
    @user = user
    @ip_address = ip_address
  end

  def execute!
    Vote.create!(question: @question, user: @user, ip_address: @ip_address)
  end
end
