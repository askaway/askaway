class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.friendly.find(params[:question_id])
    answer = Answer.new(body: params[:answer][:body],
                        question: question,
                        rep: current_user.rep)
    authorize answer
    if answer.save
      flash[:notice] = 'Answer posted.'
    else
      flash[:alert] = 'Could not post answer. It may have already been answered by someone from your party.'
    end
    redirect_to question
  end
end
