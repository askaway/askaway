class InvitationMailer < ActionMailer::Base
  default from: "Meg Howie <howiemeg@gmail.com>"

  def to_join_party(invitation)
    @invitation = invitation
    mail(to: invitation.email,
         from: invitation.inviter.name_and_email,
         subject: "#{invitation.inviter.name} has invited you to Ask Away")
  end
end
