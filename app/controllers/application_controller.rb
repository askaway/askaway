class ApplicationController < ActionController::Base
  protect_from_forgery

  def recently_asked
    Question.unanswered.accepted.limit(3)
  end

  def featured_question
   Question.accepted.answered.where(is_featured: true).first || Question.accepted.answered.first
 end
end
