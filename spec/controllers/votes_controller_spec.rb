require 'spec_helper'

describe VotesController do
  let(:question) { FactoryGirl.build_stubbed(:question) }
  let(:user) { FactoryGirl.create(:user) }
  let(:question_voter) { double(:question_voter) }

  describe "POST #create" do
    let(:request) { post :create, question_id: question.id }

    before do
      sign_in user
      Question.stub(:find).and_return(question)
      QuestionVoter.stub(:new).with(question, user).and_return(question_voter)
      question_voter.stub(:execute!)
      request
    end

    it { expect(question_voter).to have_received(:execute!) }
    it { expect(response).to redirect_to(root_path) }
  end
end
