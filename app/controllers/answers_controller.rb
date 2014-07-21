class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :history

  def edit
    authorize(answer)
  end

  def update
    authorize(answer)
    answer.edited_at = Time.zone.now
    answer.body = params[:answer][:body]
    if answer.save(answer_params)
      flash[:notice] = 'Answer edited.'
      redirect_to answer.question
    else
      flash[:alert] = 'Answer could not be edited.'
      render 'edit'
    end
  end

  def history
    authorize(answer)
    answer
  end

  def create
    question = Question.friendly.find(params[:question_id])
    answer = Answer.new(body: params[:answer][:body],
                        question: question,
                        rep: current_user.rep)
    authorize answer
    if answer.save
      flash[:notice] = 'Answer posted.' unless request.xhr?
    else
      flash[:alert] = 'Could not post answer. It may have already been answered by someone from your party.' unless request.xhr?
    end
    redirect_to question
  end

  private
    def answer
      @answer ||= Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
