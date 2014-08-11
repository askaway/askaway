json.(question, :answers_count, :body, :comments_count, :id, :is_anonymous,
      :votes_count, :user_id, :path, :user_path, :user_avatar, :vote_id,
      :can_answer )

json.user        question.user_name
json.created_at  question.created_at_description

json.answers question.answers.decorate, partial: 'answers/answer', as: :answer
