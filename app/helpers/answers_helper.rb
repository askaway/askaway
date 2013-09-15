module AnswersHelper
  def last_name_from_answer(answer)
    answer.candidate_name.split(" ").last
  end
end
