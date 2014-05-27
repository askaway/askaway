ActiveAdmin.register Question do
  permit_params :body, :email, :name, :is_anonymous

  # Work out if I care
  #scope :flagged, default: true
  #scope :default
  #scope :all

  index do
    selectable_column
    column "Question" do |question| question.body end
    column :created_at
    column :status
    column "Action" do |question|
      if question.pending? || question.flagged?
        link_to("Accept", accept_admin_question_path(question)) +
        " " +
        link_to("Decline", decline_admin_question_path(question))
      end
    end
    column "Answer" do |question|
      link_to "Answer", new_admin_answer_path(question_id: question.id)
    end
    column :name
    column :email
    actions
  end

  form do |f|
    f.inputs "Question details" do
      f.input :body
      f.input :name
      f.input :email
      #TODO can I generate this collection instead of having to define it?
      #     (maybe by making the db column an enum?)
      f.input :status, as: :select, collection: [:default, :approved, :declined, :flagged]
    end
    f.actions
  end

  member_action :approve do
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

  # FIXME Do we want this here? The public won't hit this 'endpoint' right?
  member_action :flag do
    question = Question.find(params[:id])
    question.flag!
    flash[:notice] = "Question flagged"
    redirect_to :back
  end
end
