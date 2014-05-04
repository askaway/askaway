require 'spec_helper'

describe QuestionsController do

  let(:question) { create :question }

  describe "GET index" do
    it "redirects with an empty filter" do
      Question.stub accepted: [question]
      get :index
      expect(response).to redirect_to questions_path({filter: :all})
    end

    context "when ordered by created date" do
      it "returns questions ordered by date" do
        create(:question, created_at: "2013-07-08 00:00:00")
        q2 = create(:question, created_at: "2013-08-08 00:00:00")
        get :index, filter: 'recent'
        expect(assigns(:questions)[0]).to eq(q2)
      end
    end

    context "when filtered by answered" do
      it "returns only answered questions" do
        q = create :question
        c = build_stubbed :candidate
        create :answer, question: q, candidate: c
        get :index, filter: 'answered'
        expect(assigns(:questions)).to include(q)
      end

      it "does not return unanswered questions" do
        q = create :question
        get :index, filter: 'answered'
        expect(assigns(:questions)).not_to include(q)
      end
    end
  end

  describe 'GET new' do
    it 'redirects to the sign in path' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'GET edit' do
    it 'redirects to the sign in path' do
      get :edit, id: question.id
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'POST create' do
    it 'redirects to the sign in path' do
      post :create, question: {}
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PUT update' do
    it 'redirects to the sign in path' do
      pending 'Updating questions is not implemented'
      put :update, id: question.id, question: {}
      expect(response).to redirect_to new_user_session_path
    end

  end

  describe 'POST like' do
    it 'redirects to the sign in path' do
      post :like, id: question.id
      expect(response).to redirect_to new_user_session_path
    end

  end

  describe 'DELETE like' do
    it 'redirects to the sign in path' do
      delete :like, id: question.id
      expect(response).to redirect_to new_user_session_path
    end
  end

end
