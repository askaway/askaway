json.partial! 'questions/question', question: @question.decorate

json.comments @question.comments, partial: 'comments/comment', as: :comment
