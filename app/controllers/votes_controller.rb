class VotesController < ApplicationController
  before_action :authenticate_user!
  before_filter :fetch_vote, only: :destroy

  def create
    authorize Vote
    question = Question.find(params[:question_id])
    QuestionVoter.new(question, current_user).execute!
    redirect_to(root_url)
  end

  def destroy
    authorize Vote
    @vote.destroy!
    redirect_to(root_url)
  end

  private

  def fetch_vote
    @vote = Vote.find(params[:id])
  end
end
