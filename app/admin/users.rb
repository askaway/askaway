ActiveAdmin.register User do
  permit_params :under_moderation

  filter :name
  filter :email
  filter :under_moderation

  index do
    column :id
    column :name
    column :email
    actions
  end

  form do |f|
    f.inputs do
      f.input :under_moderation
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :under_moderation
    end
  end
end
