class Answer < ActiveRecord::Base
  attr_accessible :question_id, :candidate_id, :body

  belongs_to :candidate
  belongs_to :question, inverse_of: :answers, touch: true, counter_cache: true

  validates_presence_of :candidate
  validates_presence_of :question
  validates_presence_of :body
  validates_uniqueness_of :candidate_id, scope: [:question_id]

  def candidate_name
    candidate.name
  end

  def candidate_avatar
    candidate.avatar
  end

  def candidate_authorisation
    candidate.authorisation
  end
end
