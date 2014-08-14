class AnswerDecorator < Draper::Decorator
  delegate_all

  def created_at_description
    h.time_ago_in_words(object.created_at) + ' ago'
  end

  def rep_name
    object.rep.user_name
  end

  def user_path
    h.user_path(object.rep.user)
  end

  def rep_avatar
    object.rep.user.avatar_url
  end

  def party_avatar
    object.rep.party.avatar_url(size: :xsmall)
  end

  def party_name
    object.rep.party.name
  end

  def party_path
    h.party_path(object.rep.party)
  end

  def history_path
    h.history_answer_path(object) if answer.is_edited?
  end
end
