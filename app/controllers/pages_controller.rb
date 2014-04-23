class PagesController < ApplicationController

  def styles
  end

  def another_page
    @question = Question.new
    @recently_asked = recently_asked
    @featured_question = featured_question
  end

  def individual_question
  end
end
