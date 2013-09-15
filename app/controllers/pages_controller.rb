class PagesController < ApplicationController
  # layout 'test1'

  def styles
  end

  def another_page
    @question = Question.new
    @recently_asked = recently_asked
    @featured_question = Question.accepted.answered.last
  end

    def individual_question
  end
end
