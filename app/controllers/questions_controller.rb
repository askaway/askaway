class QuestionsController < ApplicationController
  respond_to :js

  before_filter :fetch_question, only: [:show]
  before_filter :fetch_answers, only: [:show]

  def trending
    @questions = Question.top.answered.uniq.limit(20)
  end

  def new_questions
    @questions = Question.order(created_at: :desc).uniq.limit(20)
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to thanks_questions_path, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
        format.js do
          @question = Question.new
          render :create
        end
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
        format.js { render :new }
      end
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
