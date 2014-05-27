module QuestionsHelper
  def asked_by(question)
    "Asked by #{question.anonymous_name.titleize} on #{question.created_at.strftime("%b %-d")}"
  end

  def asked_by_at_time_ago(question)
    "Asked #{time_ago_in_words(question.created_at)} ago by #{question.anonymous_name.titleize}"
  end
end
