require 'spec_helper'

describe VotesController, :type => :controller do
  let(:question) { FactoryGirl.build_stubbed(:question) }
  let(:user) { FactoryGirl.create(:user) }
  let(:question_voter) { double(:question_voter) }

  describe "POST #create" do
    let(:request) { post :create, question_id: question.id }

    before do
      sign_in user
      allow(Question).to receive(:find).and_return(question)
      allow(QuestionVoter).to receive(:new).with(question, user).and_return(question_voter)
      allow(question_voter).to receive(:execute!)
      request
    end

    it { expect(question_voter).to have_received(:execute!) }
    it { expect(response).to redirect_to(root_path) }
  end
end
