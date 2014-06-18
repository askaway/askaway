require "rails_helper"

RSpec.describe InvitationMailer, :type => :mailer do
  let(:inviter) { FactoryGirl.build_stubbed(:user, name: 'Meg Howie', email: 'meg@email.com') }
  let(:party) { FactoryGirl.build_stubbed(:party, name: 'Grene Party') }
  let(:invitation) { FactoryGirl.build_stubbed(:invitation_with_token,
                                inviter: inviter,
                                email: 'Russell Goreman <russell@email.com>',
                                invitable: party) }
  let(:mail) { InvitationMailer.to_join_party(invitation) }

  it { expect(mail.subject).to eq("#{inviter.name} has invited you to Ask Away") }
  it { expect(mail.body.encoded).to match(invitation_url(invitation)) }
end
