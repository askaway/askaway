require 'policy_helper'

describe VotePolicy do
  subject { VotePolicy }
  let(:user) { FactoryGirl.create(:user) }
  let(:different_user) { FactoryGirl.create(:user) }

  permissions :destroy? do
    it 'permits user to destroy their own comment' do
      vote = FactoryGirl.create(:vote, :user => user)
      expect(subject).to permit(user, vote)
    end

    it "does not permit user to destroy another user's comment" do
      vote = FactoryGirl.create(:vote, :user => different_user)
      expect(subject).not_to permit(user, vote)
    end
  end
end
