module QuestionsHelper
  def current_user_has_voted_for?(question)
    if current_user
      current_user.votes.where(question_id: question.id).exists?
    else
      votes = session[:votes]
      votes ||= {}
      votes.includes?(question.id)
    end
  end

  def current_user_vote_id_for(question)
    if current_user
      vote = current_user.votes.find_by(question_id: question.id)
      vote.id if vote
    else
      votes = session[:votes]
      votes ||= {}
      votes[question.id] if votes.include?(question.id)
    end
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
      link_to question.user_name, question.user, class: 'emphasized'
    end
  end

end
