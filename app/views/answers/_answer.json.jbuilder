answer = answer.decorate

json.cache! ['v1', answer, 'json_items'] do
  json.(answer, :body, :user_path, :rep_avatar, :party_avatar, :party_path,
        :history_path )

  json.rep          answer.rep_name
  json.party        answer.party_name
end

json.created_at   answer.created_at_description

if AnswerPolicy.new(current_user, answer).edit?
  json.edit_path edit_answer_path(answer)
end

if current_user.try(:is_admin?)
  json.convert_path convert_admin_answer_path(answer)
end
