require 'policy_helper'

describe AnswerPolicy do
  subject { AnswerPolicy }
  let(:rep) { FactoryGirl.create(:rep) }
  let(:rep_from_same_party) { FactoryGirl.create(:rep, party: rep.party) }
  let(:rep_from_different_party) { FactoryGirl.create(:rep) }
  let(:site_admin) { FactoryGirl.create(:user, is_admin: true) }
  let(:random_user) { FactoryGirl.create(:user) }
  let(:answer) { FactoryGirl.create(:answer, rep: rep) }

  permissions :edit? do
    it { expect(subject).to permit(rep.user, answer) }
    it { expect(subject).to permit(rep_from_same_party.user, answer) }
    it { expect(subject).to permit(site_admin, answer) }
    it { expect(subject).not_to permit(rep_from_different_party.user, answer) }
    it { expect(subject).not_to permit(random_user, answer) }
  end
end
