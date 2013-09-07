class PagesController < ApplicationController
  # layout 'test1'

  def index
  end

  def another_page
    @question = Question.new
  end

    def individual_question
  end
end
