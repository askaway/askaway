require 'spec_helper'

describe QuestionsController do
  context 'POST #create' do
    it 'creates a new question' do
      expect {
        post :create, question: FactoryGirl.attributes_for(:question)
      }.to change(Question, :count).by(1)
    end

    it 'redirects to new questions page' do
      post :create, question: FactoryGirl.attributes_for(:question)
      response.should redirect_to(new_questions_path)
    end
  end

end
