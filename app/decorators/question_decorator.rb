class QuestionDecorator < Draper::Decorator
  delegate_all

  def path
    h.question_path(object)
  end

  def user_name
    return "Anonymous" if object.is_anonymous?
    object.user_name
  end

  def user_path
    return "#" if object.is_anonymous?
    h.user_path(object.user)
  end

  def user_avatar
    return h.image_url('placeholders/5-64.jpeg') if object.is_anonymous?
    object.user.avatar_url
  end

  def created_at_description
    h.time_ago_in_words(object.created_at)
  end

  def vote_id
    h.current_user_vote_id_for(object)
  end

  def can_answer
    h.user_signed_in? && h.current_user.can_answer?(object)
  end
end
