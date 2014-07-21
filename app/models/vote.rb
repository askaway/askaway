# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  user_id     :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Vote < ActiveRecord::Base
  belongs_to :question, counter_cache: true
  belongs_to :user

  validates_presence_of :user, :allow_blank => true
  validates_presence_of :ip_address, :allow_blank => true
  validates_presence_of :question
  validates_uniqueness_of :user_id, scope: :question_id, if: 'user_id.present?'
  validates_uniqueness_of :ip_address, scope: :question_id, if: 'ip_address.present?'
end
