ActiveAdmin.register Comment do
  permit_params :body, :question_id, :user_id

  form do |f|
    f.inputs do
      f.input :question, collection: Question.all.map{|q| [q.body, q.id]}
      f.input :user
      f.input :body
    end
    f.actions
  end
end
