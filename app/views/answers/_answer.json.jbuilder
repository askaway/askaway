answer = answer.decorate

json.cache! ['v1', answer, 'json_items'] do
  json.(answer, :body, :user_path, :rep_avatar, :party_avatar, :party_path,
        :history_path )
  json.created_at   answer.created_at_description
  json.rep          answer.rep_name
  json.party        answer.party_name
end

if AnswerPolicy.new(current_user, answer).edit?
  json.edit_path edit_answer_path(answer)
end
