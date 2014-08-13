class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_filter :fetch_question, only: [:show]
  before_filter :fetch_answers, only: [:show]
  after_action :verify_authorized, :except => [:trending, :new_questions, :most_votes]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def trending
    @questions = policy_scope(Question).trending.page(params[:page])
  end

  def new_questions
    @questions = policy_scope(Question).order(created_at: :desc).uniq.
                 page(params[:page])
  end

  def most_votes
    @questions = policy_scope(Question).order(votes_count: :desc).uniq.
                 page(params[:page])
  end

  def new
    authorize Question
    @question = Question.new
  end

  def show
    authorize @question
    redirect_to_canonical_show_path(@question) unless request.xhr?
    @comment = Comment.new
    @comments = @question.comments.includes(:user).order(created_at: :asc)
    if show_answer_form?
      @new_answer = Answer.new
    end
    @meta_title = "#{@question.body} | Ask Away"
    @meta_description = "#{@question.user_name} asked NZ's parties a question. Check out their answers..."
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    authorize @question

    @question.user = current_user
    if @question.save
      if @question.awaiting_review?
        flash[:notice] = 'Thanks! Your question will be reviewed and posted shortly.'
      else
        # flash[:notice] = render_to_string(partial: "flash_share_buttons",
        #                                   layout: false)
        flash[:notice] = 'Thanks! Your question has been posted.'
      end
      redirect_to new_questions_path
    else
      render action: "new"
    end
  end

  private
    def question_params
      params.require(:question).permit(:body, :is_anonymous)
    end

    def fetch_question
      @question = Question.includes(answers: :rep).friendly.find(params[:id])
    end

    def fetch_answers
      @answers = @question.answers
    end

    def show_answer_form?
      current_user.try(:can_answer?, @question)
    end

    helper_method :show_answer_form?

    def record_not_found
      flash[:alert] = 'Could not find question.'
      redirect_to(root_path)
    end
end
