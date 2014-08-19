class SearchController < ApplicationController
  def index
    @questions = Question.search(params[:q]).page(params[:page])
    respond_to do |format|
      format.html
      format.json{ render 'questions/index' }
    end
  end
end
