class RnzAdmin::QuestionsController < ApplicationController
  def edit
    authorize EmbeddedTopic
    question
  end

  def update
    authorize EmbeddedTopic
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
end
