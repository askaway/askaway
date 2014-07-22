class VotesController < ApplicationController
  before_filter :fetch_vote, only: :destroy

  #TODO: this method is kinda tricky and should be tested
  def create
    authorize Vote
    question = Question.friendly.find(params[:question_id])
    vote = Vote.create(question: question, user: current_user, ip_address: request.remote_ip)

    render json: { message: "Duplicate IP" }, status: 422 and return unless vote.valid?

    session[:votes] = {} unless session[:votes]
    session[:votes][question.id] = vote.id
    render json: vote
  end

  #TODO: this method is kinda tricky and should be tested
  def destroy
    authorize @vote

    # require login if not logged in & ip address doesn't match
    if !current_user && (@vote.ip_address != request.remote_ip)
      return render json: { message: "IP doesn't match" }, status: 422
    end

    @vote.destroy!
    session[:votes].delete(@vote.question_id) if session[:votes]
    render json: @vote
  end

  private

  def fetch_vote
    @vote = Vote.find(params[:id])
  end
end
