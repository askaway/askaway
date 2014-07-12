# == Schema Information
#
# Table name: topic_rnzs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TopicRnz < ActiveRecord::Base
  has_many :questions, inverse_of: :topic_rnz
  validates_presence_of :name
end
