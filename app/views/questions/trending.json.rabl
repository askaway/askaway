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
  node(:party) { |answer|
    answer.rep.party.name
  }
}
node(:user) { |question| 
  if question.is_anonymous? 
    "Anonymous"
  else
    question.user_name
  end
}
node(:created_at) { |question|
  time_ago_in_words(question.created_at)
}
node(:vote_id) { |question|
  vote = current_user_vote_for(question)
  vote.id unless vote.nil?
}
