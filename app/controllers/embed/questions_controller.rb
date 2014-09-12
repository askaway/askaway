class Embed::QuestionsController < ApplicationController
  after_action :verify_authorized, except: [:trending, :show]
  after_action :allow_iframe

  def trending
    @questions = policy_scope(Question).trending
    @questions = @questions.where(rnz_approved: true) if params[:rnz_approved]
    @questions = @questions.page(params[:page])
    render layout: 'embedded'
  end

  def show
    fetch_question
    @answers = @question.answers
    @question = @question.decorate
    render layout: 'embedded'
  end

  private
    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end

    def fetch_question
      @question ||= Question.common_includes
        .includes(comments: [user: [:identities, :placeholder]])
        .friendly.find(params[:id])
    end
end

