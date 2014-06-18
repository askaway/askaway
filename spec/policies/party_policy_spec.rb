require 'policy_helper'

describe PartyPolicy do
  subject { PartyPolicy }
  let(:user) { User.new }
  let(:party) { Party.new }

  [:new_members?, :invite_members?, :invited_members?, :walkthrough?].each do |action|
    permissions action do
      context 'admin' do
        before { user.is_admin = true }

        it { expect(subject).to permit(user, party) }
      end

      context 'member' do
        let(:party) { FactoryGirl.create(:party) }
        let(:user) { FactoryGirl.create(:user) }
        before { Rep.create(user: user, party: party) }

        it { expect(subject).to permit(user, party) }
      end

      context 'non-member' do
        it { expect(subject).not_to permit(user, party) }
      end

      context 'visitor' do
        it { expect(subject).not_to permit(nil, party) }
      end
    end
  end
end
