module QuestionsHelper
  def asked_by(question)
    "Asked by #{question.anonymous_name.titleize} on #{question.created_at.strftime("%b %-d")}"
  end
end
