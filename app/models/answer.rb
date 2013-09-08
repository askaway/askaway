class Answer < ActiveRecord::Base
  attr_accessible :question_id, :candidate_id, :body

  belongs_to :candidate
  belongs_to :question

  validates_presence_of :candidate
  validates_presence_of :question
  validates_presence_of :body


  def candidate_name
    candidate.name
  end

  def candidate_avatar
    candidate.avatar
  end
end
