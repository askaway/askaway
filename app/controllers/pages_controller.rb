class PagesController < ApplicationController
  # layout 'test1'

  def styles
  end

  def another_page
    @question = Question.new
  end

    def individual_question
  end
end
