ActiveAdmin.register Question do
  permit_params :body, :email, :name, :is_anonymous, :topic_id

  index do
    selectable_column
    column :body
    column "Answer" do |question|
      link_to "Answer", new_admin_answer_path(question_id: question.id)
    end
    column :name
    column :email
    actions
  end

  form do |f|
    f.inputs :body, :name, :email, :topic
    f.actions
  end
end
