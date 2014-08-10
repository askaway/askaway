class RnzAdmin::QuestionsController < ApplicationController
  after_action :verify_authorized, only: [] # skip permissions check
  before_filter :check_permissions # do permissions check manually instead

  def edit
    question
  end

  def index
    @unapproved_questions = policy_scope(Question).trending.
                            where(rnz_approved: false)
    @approved_questions   = policy_scope(Question).trending.
                            where(rnz_approved: true)
    @questions = @unapproved_questions
    @questions = @approved_questions if params[:approved] == 'true'
  end

  def approve
    question.update_attribute(:rnz_approved, true)
    flash[:notice] = "Question approved."
    redirect_to rnz_admin_questions_path
  end

  def unapprove
    question.update_attribute(:rnz_approved, false)
    flash[:notice] = "Question unapproved."
    redirect_to rnz_admin_questions_path
  end

  def update
    question
    question.embedded_topic = EmbeddedTopic.find(params[:question][:embedded_topic_id])
    question.save!
    flash[:notice] = "Question assigned to #{question.embedded_topic.name}."
    redirect_to rnz_admin_embedded_topics_path
  end

  private
    def question
      @question ||= Question.friendly.find(params[:id])
    end

    def check_permissions
      # Couldn't get pundit to work with namespaces so had to do this manually
      unless current_user.try(:can_embed?)
        raise NotAuthorizedError.new("not allowed to do this")
      end
    end
end
