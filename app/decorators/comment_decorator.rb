class CommentDecorator < Draper::Decorator
  delegate_all

  def created_at_description
    h.time_ago_in_words(object.created_at)
  end

  def updated_at_description
    h.time_ago_in_words(object.updated_at)
  end

  def user_name
    object.user.name
  end

  def user_path
    h.user_path(object.user)
  end

  def user_avatar
    object.user.avatar_url
  end

  def path
    h.comment_path(object)
  end
end
