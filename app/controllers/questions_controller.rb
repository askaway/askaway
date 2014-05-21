class QuestionsController < ApplicationController
  respond_to :js

  before_filter :fetch_question, only: [:show, :like, :unlike]
  before_filter :fetch_answers, only: :show

  # GET /questions
  # GET /questions.json
  def index
    @question = Question.new
    page = params[:page] || 1
    @filter = params[:filter]
    if @filter.blank?
      redirect_to(questions_path({filter: :answered})) and return
    end
    @questions = Question.ai
    if params[:filter] == 'recent'
      @questions = @questions.recent.page(page)
    elsif params[:filter] == 'top'
      @questions = @questions.unanswered.top.page(page)
    elsif params[:filter] == 'all'
      @questions = @questions.recent.page(page)
    elsif params[:filter] == 'answered'
      @questions = @questions.answered.top.page(page)
    end
    if params[:q].present?
      @questions = @questions.search_scope(params[:q])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  def show
    if @question.status == 'accepted'
      @recently_asked = recently_asked
      @hide_see_comments = true
      render 'show'
    else
      redirect_to root_path
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
