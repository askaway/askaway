class RepTopic < ActiveRecord::Base
  belongs_to :rep
  belongs_to :topic
  validates_presence_of :rep
  validates_presence_of :topic
  validates_uniqueness_of :rep_id, scope: :topic_id

  delegate :name, to: :topic, prefix: false
end
