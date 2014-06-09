ActiveAdmin.register Answer do
  permit_params :question_id, :rep_id, :body

  member_action :new do
    @answer = Answer.new(question_id: params[:question_id])
  end

  member_action :create do
    @answer = Answer.new(params[:answer])
    if @answer.save
      flash[:notice] = "Answer created for #{@answer.rep.name}."
      redirect_to new_admin_answer_path(question_id: @answer.question_id)
    else
      flash[:error] = "There were errors in the form. See below."
      render action: :new
    end
  end

  form do |f|
    f.inputs "Content" do
      f.input :rep
      f.input :question, member_label: :label, collection: Question.accepted
      f.input :body
   end
   f.actions
 end
end
