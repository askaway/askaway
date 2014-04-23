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
        q1 = FactoryGirl.create(:question, created_at: "2013-07-08 00:00:00")
        q2 = FactoryGirl.create(:question, created_at: "2013-08-08 00:00:00")
        get :index, filter: 'recent'
        expect(assigns(:questions)[0]).to eq(q2)
      end
    end

    context "when filtered by answered" do
      it "returns only answered questions" do
        q = FactoryGirl.create :question
        c = FactoryGirl.build_stubbed :candidate
        a = FactoryGirl.create :answer, question: q, candidate: c
        get :index, filter: 'answered'
        expect(assigns(:questions)).to include(q)
      end

      it "does not return unanswered questions" do
        q = FactoryGirl.create :question
        get :index, filter: 'answered'
        expect(assigns(:questions)).not_to include(q)
      end
    end
  end
end
