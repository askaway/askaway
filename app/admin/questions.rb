ActiveAdmin.register Question do
  permit_params :body, :topic_id

  index do
    selectable_column
    column :body
    column :user do |question|
      link_to question.user.name, question.user
    end
    actions
  end

  form do |f|
    f.inputs :body, :topic
    f.actions
  end
end
