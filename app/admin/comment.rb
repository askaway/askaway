ActiveAdmin.register Comment do
  permit_params :body, :question_id, :user_id, :workflow_state

  scope :all
  scope :awaiting_review

  form do |f|
    f.inputs do
      f.input :question, collection: Question.all.map{|q| [q.body, q.id]}
      f.input :user
      f.input :body
      f.input :workflow_state, as: :select, collection: Comment.workflow_spec.states.keys
    end
    f.actions
  end
end
