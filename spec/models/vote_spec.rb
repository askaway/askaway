require 'rails_helper'

describe Vote, :type => :model do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  it { is_expected.to validate_presence_of(:question) }

  describe '#create' do
    it 'increments vote.question.votes_count' do
      expect{
        Vote.create!(question: question, user: user)
      }.to change{ question.reload.votes_count }.by(1)
    end
  end
end
