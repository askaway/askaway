# == Schema Information
#
# Table name: embedded_topics
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EmbeddedTopic < ActiveRecord::Base
  has_many :questions, inverse_of: :embedded_topic
  validates_presence_of :name
end
