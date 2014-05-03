ActiveAdmin.register Question do
  scope :flagged, default: true
  scope :pending
  scope :all

  index do
    selectable_column
    column :created_at
    column :status
    column "Action" do |question|
      if question.pending? || question.flagged?
        link_to("Accept", accept_admin_question_path(question)) +
        " " +
        link_to("Decline", decline_admin_question_path(question))
      end
    end
    column "Question" do |question| question.body end
    column "Featured" do |question|
      if question.is_featured?
        content_tag(:strong, "Featured")
      elsif !question.is_featured? && question.accepted? && question.answered?
        link_to "feature", feature_admin_question_path(question)
      end
    end
    column :name
    column :email
    default_actions
  end

  batch_action :accept do |selection|
    Question.find(selection).each do |question|
      question.accept!
    end
  end

  form do |f|
    #TODO make status a dropdown
    f.inputs :body, :name, :email, :status
    f.actions
  end

  member_action :accept do
    question = Question.find(params[:id])
    question.accept!
    flash[:notice] = "Question accepted"
    redirect_to :back
  end

  member_action :decline do
    question = Question.find(params[:id])
    question.decline!
    flash[:notice] = "Question declined"
    redirect_to :back
  end

  member_action :feature do
    Question.update_all(is_featured: false)
    question = Question.find(params[:id])
    question.is_featured = true
    question.save
    flash[:notice] = "Question featured"
    redirect_to :back
  end

  # FIXME Do we want this here? The public won't hit this 'endpoing' right?
  member_action :flag do
    question = Question.find(params[:id])
    question.flag!
    flash[:notice] = "Question flagged"
    redirect_to :back
  end
end
