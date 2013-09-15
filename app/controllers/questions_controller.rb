class QuestionsController < ApplicationController
  respond_to :js

  before_filter :fetch_question, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_filter :fetch_answers, only: :show

  # GET /questions
  # GET /questions.json
  def index
    page = params[:page] || 1
    @filter = params[:filter]
    @questions = Question.accepted.uniq.includes(answers: :candidate)
    if params[:filter] == 'recent'
      @questions = @questions.recent.page(page)
    elsif params[:filter] == 'top'
      @questions = @questions.unanswered.top.page(page)
    elsif params[:filter] == 'all'
      @questions = @questions.recent.page(page)
    else #if params[:filter] == 'answered'
      @questions = @questions.answered.recent.page(page)
    end
    if params[:q]
      @questions = @questions.search_scope(params[:q])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @recently_asked = Question.accepted.limit(5)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
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

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
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

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  def like
    puts "I like!"
    @question.increment
    head :accepted
  end

  def unlike
    puts "I no like!"
    @question.decrement
    head :accepted
  end

  private

  def fetch_question
    @question = Question.includes(answers: :candidate).find(params[:id])
  end

  def fetch_answers
    @answers = @question.answers
  end
end
