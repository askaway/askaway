class ConvertAnswerToComment
  class << self
    def execute(answer)
      comment = Comment.create!(user: answer.rep.user,
                                body: answer.body,
                                question: answer.question)
      answer.destroy
      comment
    end
  end
end
