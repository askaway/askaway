class Embed::QuestionsController < ApplicationController
  after_action :verify_authorized, except: [:trending]
  after_action :allow_iframe, only: :trending

  def trending
    @questions = policy_scope(Question).trending
    @questions = @questions.where(rnz_approved: true) if params[:rnz_approved]
    @questions = @questions.page(params[:page])
    render layout: 'embedded'
  end

  private
    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end
end

