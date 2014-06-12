ActiveAdmin.register Question do
  permit_params :body, :email, :name, :is_anonymous, :topic_id

  index do
    selectable_column
    column :body
    column :user
    column "Answer" do |question|
      link_to "Answer", new_admin_answer_path(question_id: question.id)
    end
    actions
  end

  form do |f|
    f.inputs :body, :user, :topic
    f.actions
  end
end
