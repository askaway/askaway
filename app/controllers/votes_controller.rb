class VotesController < ApplicationController
  before_action :authenticate_user!
  before_filter :fetch_vote, only: :destroy

  def create
    authorize Vote
    question = Question.find(params[:question_id])
    vote = QuestionVoter.new(question, current_user).execute!
    render json: vote
  end

  def destroy
    authorize @vote
    @vote.destroy!
    render json: @vote
  end

  private

  def fetch_vote
    @vote = Vote.find(params[:id])
  end
end
