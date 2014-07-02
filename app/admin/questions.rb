ActiveAdmin.register Question do
  permit_params :body, :topic_id, :workflow_state

  scope :awaiting_review

  index do
    selectable_column
    column :body
    column :user do |question|
      link_to question.user.name, question.user
    end
    column :review do |question|
      if question.awaiting_review?
        link = link_to "Accept", accept_admin_question_path(question), method: :put
        link += " "
        link += link_to "Reject", reject_admin_question_path(question), method: :put
      elsif question.accepted? || question.rejected?
        question.workflow_state.capitalize
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :body
      f.input :topic
      f.input :workflow_state, as: :select, collection: Question.workflow_spec.states.keys
    end
    f.actions
  end

  member_action :accept, method: :put do
    question = Question.friendly.find(params[:id])
    question.accept!
    redirect_to admin_questions_url, :notice => "Question accepted."
  end

  member_action :reject, method: :put do
    question = Question.friendly.find(params[:id])
    question.reject!
    redirect_to admin_questions_url, :notice => "Question rejected."
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
