class ConvertAnswerToComment
  class << self
    def execute(answer)
      comment = Comment.create!(user: answer.rep.user,
                                body: answer.body,
                                question: answer.question,
                                created_at: answer.created_at)
      answer.destroy
      comment
    end
  end
end
