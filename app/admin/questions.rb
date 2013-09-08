ActiveAdmin.register Question do
  form do |f|
    f.inputs :body, :name, :email
    f.inputs "stuff" do
      f.input :status, :as => :select,  :collection => Question::STATUSES
    end
    f.actions
  end

  member_action :update, :method => :put do
    question = Question.find(params[:id])
    question.status = params[:question].delete(:status)
    question.update_attributes(params[:question])
    redirect_to action: :show
  end
end
