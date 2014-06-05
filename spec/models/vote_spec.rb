require 'spec_helper'

describe Vote do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:question) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }

  describe '#create' do
    it 'increments vote.question.votes_count' do
      expect{
        Vote.create!(question: question, user: user)
      }.to change{ question.reload.votes_count }.by(1)
    end
  end
end
