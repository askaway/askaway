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

  belongs_to :rep
  belongs_to :question, inverse_of: :answers, touch: true, counter_cache: true

  validates_presence_of :rep
  validates_presence_of :question
  validates_presence_of :body
  validates_uniqueness_of :rep_id, scope: [:question_id]

  def rep_name
    rep.name
  end

  def rep_avatar
    rep.avatar
  end

  def rep_authorisation
    rep.authorisation
  end
end
