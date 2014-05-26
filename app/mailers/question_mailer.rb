class QuestionMailer < ActionMailer::Base
  default from: "Meg from AskAway <askawaynz@gmail.com>"

  def question_asked(question)
    @question = question
    mail(from: "Ask Away <askawaynz@gmail.com>", 
         to: 'askawaynz@gmail.com',
         subject: "Question: #{@question.body}")
  end
end
