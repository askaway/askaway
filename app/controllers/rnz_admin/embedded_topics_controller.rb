class RnzAdmin::EmbeddedTopicsController < ApplicationController
  before_filter :unassigned_questions

  def index
    authorize EmbeddedTopic
    @questions = policy_scope(Question).trending.
                 where(embedded_topic_id: nil)#.page(params[:page])
  end

  def new
    authorize EmbeddedTopic
    @embedded_topic = EmbeddedTopic.new
  end

  def show
    @embedded_topic = EmbeddedTopic.find(params[:id])
    @questions = policy_scope(Question).trending.
                 where(embedded_topic_id: params[:id])#.page(params[:page])
    authorize @embedded_topic
  end

  def create
    @embedded_topic = EmbeddedTopic.create!(name: params[:embedded_topic][:name])
    flash[:notice] = "#{@embedded_topic.name} topic created."
    authorize @embedded_topic
    redirect_to rnz_admin_embedded_topics_path
  end

  def edit
    @embedded_topic = EmbeddedTopic.find(params[:id])
    authorize @embedded_topic
  end

  def update
    @embedded_topic = EmbeddedTopic.find(params[:id])
    authorize @embedded_topic
    @embedded_topic.name = params[:embedded_topic][:name]
    @embedded_topic.save!
    flash[:notice] = 'Topic name updated.'
    redirect_to rnz_admin_embedded_topics_path
  end

  private
    def unassigned_questions
      @unassigned_questions ||= Question.where(embedded_topic_id: nil)
    end
end
