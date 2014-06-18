module QuestionsHelper
  def current_user_has_voted_for?(question)
    current_user && current_user.votes.where(question_id: question.id).exists?
  end

  def current_user_vote_for(question)
    current_user && current_user.votes.find_by(question_id: question.id)
  end

  def asked_by_at_time_ago(question)
    result = time_ago_in_words(question.created_at).html_safe
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
