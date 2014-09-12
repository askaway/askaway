ActiveAdmin.register Question do
  config.sort_order = 'ranking_cache_asc'

  permit_params :body, :topic_id, :embedded_topic_id, :workflow_state

  scope :all
  scope :awaiting_review

  action_item do
    link_to "Update Rankings", update_rankings_admin_questions_path, :method => :put
  end

  index do
    selectable_column
    column "#", sortable: :ranking_cache do |question|
      question.ranking_cache
    end
    column :votes, sortable: :votes_count do |question|
      question.votes_count
    end
    column :body
    column :user do |question|
      link_to question.user.name, question.user
    end
    column :created, sortable: :created_at do |question|
      time_ago_in_words(question.created_at)
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
    column :email do |question|
      if question.topic.nil?
        link_to "Assign", edit_admin_question_path(question)
      elsif question.reminder_email.nil?
        link_to "Email"
      else
        ' '
      end
    end
    column :Answers do |question|
      link_to "See answers", admin_answers_path + "?q%5Bquestion_id_eq%5D=#{question.id}"
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :body
      f.input :topic, as: :select, collection: Topic.order('name ASC')
      f.input :embedded_topic, as: :select, collection: EmbeddedTopic.order('name ASC')
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

  collection_action :update_rankings, method: :put do
    QuestionRankingCache.update
    flash[:notice] = "Question rankings have been updated for the admin panel."
    redirect_to admin_questions_path
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end
end
