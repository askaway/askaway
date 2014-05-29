class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: :new
  before_filter :fetch_question, only: [:show]
  before_filter :fetch_answers, only: [:show]

  def trending
    @questions = Question.top.answered.uniq.limit(20)
  end

  def new_questions
    @questions = Question.order(created_at: :desc).uniq.limit(20)
  end

  def new
    @question = Question.new
  end

  def show
    @comment = Comment.new
    @comments = @question.comments.includes(:user).order(created_at: :desc)
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to new_questions_path, notice: 'Your question has been posted.'
    else
      render action: "new"
    end
  end

  private

  def question_params
    params.require(:question).permit(:body, :email, :name, :is_anonymous)
  end

  def fetch_question
    @question = Question.includes(answers: :candidate).find(params[:id])
  end

  def fetch_answers
    @answers = @question.answers
  end
end
