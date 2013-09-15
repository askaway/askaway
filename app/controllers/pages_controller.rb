class PagesController < ApplicationController
  # layout 'test1'

  def styles
  end

  def another_page
    @question = Question.new
    @recently_asked = recently_asked
  end

    def individual_question
  end
end
