class QuestionMailer < ActionMailer::Base
  default from: "Meg from AskAway <meg@askaway.co.nz>"

  def question_accepted(question)
    @question = question
    mail(to: question.name_and_email, subject: "I've posted your question on AskAway")
  end
end
