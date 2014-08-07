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
  has_many :rep_topics
  has_many :topics, through: :rep_topics

  validates_uniqueness_of :user_id

  delegate :name, to: :user, prefix: :user
  delegate :name, :avatar_url, to: :user

  scope :unassigned,
    -> { joins("LEFT JOIN rep_topics ON reps.id = rep_topics.rep_id").
         where('rep_topics.topic_id IS NULL') }

  scope :assigned,
    -> { joins("LEFT JOIN rep_topics ON reps.id = rep_topics.rep_id").
         where('rep_topics.topic_id IS NOT NULL').uniq }

  attr_accessor :new_topic, :unassign_topic
end
