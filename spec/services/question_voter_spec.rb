require 'spec_helper'

describe QuestionVoter do
  class Vote; end
  let(:question) { double(:question) }
  let(:user) { double(:user) }
  let(:question_voter) { QuestionVoter.new(question, user) }

  describe '#execute!' do
    it 'creates a vote' do
      expect(Vote).to receive(:create!).with(question: question, user: user)
      question_voter.execute!
    end
  end
end
