collection @questions
attributes :answers_count, :body, :comments_count, :id, :is_anonymous, :votes_count, :user_id
child(:answers) { 
  attributes :body
  node(:created_at) { |answer|
    time_ago_in_words(answer.created_at)
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
  vote = current_user_vote_for(question)
  vote.id unless vote.nil?
}
