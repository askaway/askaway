class AnswerMailer < ActionMailer::Base
  default from: 'Meg Howie <howiemeg@gmail.com>'

  def asker_notification(answer)
    @answer = answer
    @question = @answer.question
    @user = @question.user
    @rep = @answer.rep
    @party = @rep.party
    mail(to: @user.email,
      subject: "Your question has been answered by the #{@party.name}")
  end
end
