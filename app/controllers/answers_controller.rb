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
    error_message = 'Could not post answer. It may have already been answered by someone from your party.'
    authorize answer
    if answer.save
      flash[:notice] = 'Answer posted.' unless request.xhr?
      redirect_to question
    elsif request.xhr?
      render json: { message: error_message }, status: 422
    else
      flash[:alert] = error_message
      redirect_to question
    end
  end

  private
    def answer
      @answer ||= Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
