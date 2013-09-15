module QuestionsHelper
  def asked_by(question)
    if question.is_anonymous?
      "Asked by anonymous on #{question.created_at.strftime("%b %-d")}"
    else
      "Asked by #{question.name.titleize} on #{question.created_at.strftime("%b %-d")}"
    end
  end
end
