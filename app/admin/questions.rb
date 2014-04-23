ActiveAdmin.register Question do
  scope :all

  index do
    selectable_column
    column :body
    column "Answer" do |question|
      if question.accepted?
        link_to "Answer", new_admin_answer_path(question_id: question.id)
      end
    end
    column :name
    column :email
    column :status
    column "Accept" do |question|
      unless question.accepted?
        link_to "Accept", accept_admin_question_path(question)
      end
    end
    column "Featured" do |question|
      if question.is_featured?
        content_tag(:strong, "Featured")
      elsif !question.is_featured? && question.accepted? && question.answered?
        link_to "feature", feature_admin_question_path(question)
      end
    end
    default_actions
  end

  batch_action :accept do |selection|
    Question.find(selection).each do |question|
      question.accept!
    end
  end

  form do |f|
    f.inputs :body, :name, :email
    f.actions
  end

  member_action :accept do
    question = Question.find(params[:id])
    question.accept!
    flash[:notice] = "Question accepted"
    redirect_to action: :index
  end

  member_action :feature do
    Question.update_all(is_featured: false)
    question = Question.find(params[:id])
    question.is_featured = true
    question.save
    flash[:notice] = "Question featured"
    redirect_to action: :index

  end

  member_action :answer do
    question = Question.find(params[:id])
    question.accept!
    flash[:notice] = "Question accepted"
    redirect_to action: :index
  end
end
