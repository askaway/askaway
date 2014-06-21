ActiveAdmin.register Answer do
  permit_params :question_id, :rep_id, :body
end
