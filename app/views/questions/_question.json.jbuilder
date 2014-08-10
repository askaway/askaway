json.(question, :answers_count, :body, :comments_count, :id, :is_anonymous,
      :votes_count, :user_id)
json.path        question_path(question)
json.user        (question.is_anonymous?)? "Anonymous" : question.user_name
json.user_path   (question.is_anonymous?)? "#" : user_path(question.user)
json.user_avatar (question.is_anonymous?)? image_url('placeholders/5-64.jpeg') : question.user.avatar_url
json.created_at  time_ago_in_words(question.created_at)
json.vote_id     current_user_vote_id_for(question)
json.can_answer  current_user.can_answer?(question) if current_user

json.answers question.answers do |answer|
  json.cache! ['v1', answer, 'json_question_items'] do
    json.(answer, :body)
    json.created_at   time_ago_in_words(answer.created_at) + ' ago'
    json.rep          answer.rep.user_name
    json.user_path    user_path(answer.rep.user)
    json.rep_avatar   answer.rep.user.avatar_url
    json.party_avatar answer.rep.party.avatar_url(size: :xsmall)
    json.party        answer.rep.party.name
    json.party_path   party_path(answer.rep.party)
    json.history_path history_answer_path(answer) if answer.is_edited?
  end

  if AnswerPolicy.new(current_user, answer).edit?
    json.edit_path edit_answer_path(answer)
  end
end
