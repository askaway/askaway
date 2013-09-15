class ApplicationController < ActionController::Base
  protect_from_forgery

  def recently_asked
    Question.unanswered.accepted.limit(5)
  end
end
