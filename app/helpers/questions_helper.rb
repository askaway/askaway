module QuestionsHelper
  def asked_by_at_time_ago(question)
    result = 'Asked '.html_safe
    result += time_ago_in_words(question.created_at)
    result += ' ago by '.html_safe
    result += question_linked_user_name(question)
  end

  def question_linked_user_name(question)
    if question.is_anonymous?
      "Anonymous"
    else
      link_to question.user_name, question.user
    end
  end
end
