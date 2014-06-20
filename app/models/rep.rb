# == Schema Information
#
# Table name: reps
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  party_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Rep < ActiveRecord::Base
  belongs_to :user
  belongs_to :party
  has_many :answers

  validates_uniqueness_of :user_id

  delegate :name, to: :user, prefix: :user
end
