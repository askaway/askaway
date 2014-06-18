require 'policy_helper'

describe VotePolicy do
  subject { VotePolicy }
  let(:user) { FactoryGirl.create(:user) }
  let(:different_user) { FactoryGirl.create(:user) }

  [:destroy?].each do |action|
    permissions action do
      context 'owner' do
        let(:vote) { FactoryGirl.create(:vote, :user => user) }

        it { expect(subject).to permit(user, vote) }
      end

      context 'non-owner' do
        let(:vote) { FactoryGirl.create(:vote, :user => different_user) }

        it { expect(subject).not_to permit(user, vote) }
      end

      context 'visitor' do
        let(:vote) { FactoryGirl.create(:vote, :user => different_user ) }
        it { expect(subject).not_to permit(nil, vote) }
      end
    end
  end
end
