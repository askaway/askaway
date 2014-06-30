class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_filter :fetch_question, only: [:show]
  before_filter :fetch_answers, only: [:show]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def trending
    authorize Question
    @questions = Question.trending.page(params[:page])
  end

  def new_questions
    authorize Question
    @questions = Question.order(created_at: :desc).uniq.
                 page(params[:page])
  end

  def new
    authorize Question
    @question = Question.new
  end

  def show
    authorize @question
    @comment = Comment.new
    @comments = @question.comments.includes(:user).order(created_at: :desc)
    if show_answer_form?
      @new_answer = Answer.new
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    authorize @question

    @question.user = current_user
    if @question.save
      redirect_to new_questions_path, notice: 'Your question has been posted.'
    else
      render action: "new"
    end
  end

  private
    def question_params
      params.require(:question).permit(:body, :topic_id, :is_anonymous)
    end

    def fetch_question
      @question = Question.includes(answers: :rep).friendly.find(params[:id])
    end

    def fetch_answers
      @answers = @question.answers
    end

    def show_answer_form?
      current_user.try(:is_rep?) &&
        !Question.has_answer_from_party?(@question, current_user.party)
    end
    helper_method :show_answer_form?

    def record_not_found
      flash[:alert] = 'Could not find question.'
      redirect_to(root_path)
    end
end
