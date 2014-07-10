require 'policy_helper'

describe InvitationPolicy do
  subject { InvitationPolicy }
  let(:party) { FactoryGirl.create(:party) }
  let(:rep) { FactoryGirl.create(:rep, party: party) }
  let(:site_admin) { FactoryGirl.create(:user, is_admin: true) }
  let(:user) { FactoryGirl.create(:user) }
  let(:invitation) { FactoryGirl.create(:invitation, invitable: party) }

  permissions :destroy? do
    it 'permits site admin to destroy invitation' do
      expect(subject).to permit(site_admin, invitation)
    end

    it "permits party rep to destroy invitation to party" do
      expect(subject).to permit(rep.user, invitation)
    end

    it 'does not permit user to destroy invitation' do
      expect(subject).not_to permit(user, invitation)
    end
  end
end
