class AnswersController < ApplicationController
  def show
    @answer = Answer.find(params[:id])
    @recently_asked = recently_asked
    @hide_see_comments = true
  end
end
