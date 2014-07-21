collection @questions
attributes :answers_count, :body, :comments_count, :id, :is_anonymous, :votes_count, :user_id
child(:answers) { 
  attributes :body
  node(:created_at) { |answer|
    time_ago_in_words(answer.created_at) + ' ago'
  }
  node(:rep) { |answer|
    answer.rep.user_name
  }
  node(:user_path) { |answer|
    user_path(answer.rep.user)
  }
  node(:rep_avatar) { |answer|
    answer.rep.user.gravatar_url
  }
  node(:party) { |answer|
    answer.rep.party.name
  }
  node(:party_path) { |answer|
    party_path(answer.rep.party)
  }
  node(:edit_path) { |answer|
    if AnswerPolicy.new(current_user, answer).edit?
      edit_answer_path(answer)
    end
  }
  node(:history_path) { |answer|
    if answer.is_edited?
      history_answer_path(answer)
    end
  }
}
node(:path) { |question|
  question_path(question)
}
node(:user) { |question| 
  if question.is_anonymous? 
    "Anonymous"
  else
    question.user_name
  end
}
node(:user_path) { |question|
  if question.is_anonymous?
    "#"
  else
    user_path(question.user)
  end
}
node(:user_avatar) { |question|
  if question.is_anonymous?
    "http://placekitten.com/64/64"
  else
    question.user.gravatar_url
  end
}
node(:created_at) { |question|
  time_ago_in_words(question.created_at)
}
node(:vote_id) { |question|
  current_user_vote_id_for(question)
}
