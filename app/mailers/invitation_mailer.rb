class InvitationMailer < ActionMailer::Base
  default from: '"Meg Howie (Ask Away)" <meg@askaway.org.nz>'

  def to_join_party(invitation)
    @invitation = invitation
    mail(to: invitation.email,
         subject: "#{invitation.inviter.name} has invited you to Ask Away")
  end
end
