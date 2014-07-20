require 'rails_helper'

describe QuestionVoter do
  class Vote; end
  let(:question) { double(:question) }
  let(:user) { double(:user) }
  let(:ip_address) { "127.0.0.1" }
  let(:question_voter) { QuestionVoter.new(question, user, ip_address) }

  describe '#execute!' do
    it 'creates a vote' do
      expect(Vote).to receive(:create!).with(question: question, user: user, ip_address: ip_address)
      question_voter.execute!
    end
  end
end
