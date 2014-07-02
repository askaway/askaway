class AnswerMailer < ActionMailer::Base
  default from: 'Meg Howie <howiemeg@gmail.com>'

  def asker_notification(answer)
    @answer = answer
    @user = answer.question.user
    mail(to: @user.email,
      subject: "Your question has been answered by the #{@answer.rep.party.name}")
  end
end
