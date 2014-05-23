# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  body         :text
#  candidate_id :integer
#  question_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Answer < ActiveRecord::Base

  belongs_to :candidate
  belongs_to :question, inverse_of: :answers, touch: true, counter_cache: true

  validates_presence_of :candidate
  validates_presence_of :question
  validates_presence_of :body
  validates_uniqueness_of :candidate_id, scope: [:question_id]

  def self.shuffled
    if ActiveRecord::Base.connection.adapter_name == "mysql"
      order("RAND()")
    else
      order("RANDOM()")
    end
  end

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
