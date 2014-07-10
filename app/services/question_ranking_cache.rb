class QuestionRankingCache
  def self.update
    i = 1
    Question.trending.each do |question|
      question.update_attribute(:ranking_cache, i)
      i += 1
    end
  end
end
