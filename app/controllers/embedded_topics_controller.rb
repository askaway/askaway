class EmbeddedTopicsController < ApplicationController
  after_action :verify_authorized, except: :show
  after_action :allow_iframe, only: :show

  def show
    @questions = policy_scope(Question).trending.
                 where(embedded_topic_id: params[:id]).page(params[:page])
    render layout: 'embedded'
  end

  def admin
    authorize EmbeddedTopic
    @questions = Question.trending
  end

  private
    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end
end

