class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_filter :fetch_question, only: :create

  def create
    @comment = @question.comments.new(comment_params)
    @comment.user = current_user
    authorize @comment
    if @comment.save
      redirect_to @question
    else
      render template: "questions/show"
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    question = comment.question
    authorize comment
    comment.destroy!
    flash[:notice] = 'Comment deleted.'
    redirect_to question
  end

  private

  def fetch_question
    @question = Question.includes(answers: :rep).friendly.find(params[:question_id])
    @answers = @question.answers
  end

  def comment_params
    params.require(:comment).permit(:body, :email)
  end
end
