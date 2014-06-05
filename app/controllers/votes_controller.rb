class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find(params[:question_id])
    QuestionVoter.new(question, current_user).execute!
    redirect_to(root_url)
  end
end
