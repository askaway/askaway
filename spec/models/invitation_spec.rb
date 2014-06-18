require 'rails_helper'

describe Invitation, :type => :model do
  let(:party) { FactoryGirl.build_stubbed(:party) }
  let(:inviter) { FactoryGirl.build_stubbed(:user) }
  let(:mailer) { double(:mailer, to_join_party: true) }

  it { is_expected.to belong_to(:inviter) }
  it { is_expected.to belong_to(:invitable) }

  it { is_expected.to validate_uniqueness_of(:token) }
  it { is_expected.to validate_presence_of(:inviter_id) }

  describe '#accept!' do
    let(:party) { FactoryGirl.create(:party) }
    let(:acceptor) { FactoryGirl.create(:user) }
    let(:invitation) { Invitation.create!(email: 'meg@example.org',
                           intent: 'to_join_party',
                           invitable: party,
                           inviter: inviter) }

    context 'acceptor is not a party member' do
      before do
        invitation.accept!(acceptor)
      end

      it { expect(invitation.reload.accepted_at).to_not be_nil }
      it { expect(invitation.reload.acceptor_id).to eq(acceptor.id) }
      it { expect(invitation.invitable.rep_users).to include(acceptor) }
    end

    context 'acceptor is already a party rep' do
      before { FactoryGirl.create(:rep, user: acceptor, party: party) }

      it { expect(invitation.accept!(acceptor)).to eq(false) }

      it 'does not assign accepted_at' do
        invitation.accept!(acceptor)
        expect(invitation.accepted_at).to be_nil
      end
    end
  end

  describe '#accepted?' do
    let(:invitation) { Invitation.create!(email: 'meg@example.org',
                           intent: 'to_join_party',
                           invitable: party,
                           inviter: inviter) }

    context 'accepted_at is populated' do
      before { invitation.update_attribute(:accepted_at, Time.zone.now) }

      it { expect(invitation).to be_accepted }
    end

    context 'accepted_at is nil' do
      it { expect(invitation).to_not be_accepted }
    end
  end

  describe '.create!' do
    let(:invitation) { Invitation.create!(email: 'meg@example.org',
                               intent: 'to_join_party',
                               invitable: party,
                               inviter: inviter) }
    it { expect(invitation.token).to be_present }
  end

  describe '.invite!' do
    let(:invitation) { double(:invitation) }
    let(:name) { 'Jon Lemmon' }
    let(:email) { 'jon@example.org' }
    let(:invite!) { Invitation.invite!(
                    email: email,
                    name: name,
                    intent: 'to_join_party',
                    invitable: party,
                    inviter: inviter) }

    before do
      allow(Invitation).to receive(:create!).and_return(invitation)
      allow(InvitationMailer).to receive(:delay).and_return(mailer)
    end

    it 'emails reps' do
      expect(InvitationMailer).to receive(:delay)
      expect(mailer).to receive(:to_join_party).with(invitation)
      invite!
    end

    it { expect(invite!).to eq(invitation) }
  end

  describe '.batch_invite!' do
    let(:invitation) { double(:invitation) }
    let(:batch_invite!) { Invitation.batch_invite!(
                emails: emails,
                intent: 'to_join_party',
                invitable: party,
                inviter: inviter) }

    before do
      allow(Invitation).to receive(:create!).and_return(invitation)
      allow(InvitationMailer).to receive(:delay).and_return(mailer)
    end

    context 'given valid emails' do
      let(:emails) { 'jo@example.org, "Meg Howie" <meg@example.org>' }
      let(:invitations) { [invitation, invitation] }

      it 'splits up name and email and invites' do
        expect(Invitation).to receive(:invite!).
                              with(email: 'jo@example.org',
                                   name: nil,
                                   intent: 'to_join_party',
                                   invitable: party,
                                   inviter: inviter).
                              and_return(invitation)
        expect(Invitation).to receive(:invite!).
                              with(email: 'meg@example.org',
                                   name: 'Meg Howie',
                                   intent: 'to_join_party',
                                   invitable: party,
                                   inviter: inviter).
                              and_return(invitation)
        batch_invite!
      end

      it { expect(batch_invite!).to eq(invitations) }
    end

    context 'given invalid emails' do
      let(:emails) { 'jo@example.org meg@example.org' }

      it { expect(batch_invite!).to be false }

      it 'does not create invitations' do
        expect(Invitation).to_not receive(:create!)
        batch_invite!
      end

      it 'returns false' do
        expect(Invitation).to_not receive(:create!)
        expect(batch_invite!).to eq(false)
      end
    end
  end
end
