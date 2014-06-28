# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  rep_id      :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Answer < ActiveRecord::Base
  BODY_MAX_LENGTH = 350

  belongs_to :rep, inverse_of: :answers
  belongs_to :question, inverse_of: :answers, touch: true, counter_cache: true

  validates_presence_of :rep
  validates_presence_of :question
  validates_presence_of :body
  validates_length_of :body, maximum: BODY_MAX_LENGTH
  validates_uniqueness_of :rep_id, scope: [:question_id]
  validate :one_answer_per_party

  def rep_name
    rep.name
  end

  def rep_avatar
    rep.avatar
  end

  def rep_authorisation
    rep.authorisation
  end

  private
    def one_answer_per_party
      if Question.has_answer_from_party?(question, rep.party)
        errors.add(:rep, "This question has already been answered by the party.")
      end
    end
end
