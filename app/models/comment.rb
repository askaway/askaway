# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  question_id :integer
#  user_id     :integer
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Comment < ActiveRecord::Base
  include ReviewFilter

  belongs_to :question, touch: true, counter_cache: true
  belongs_to :user
  validates :body, presence: true
  validates :question, presence: true

  def self.common_includes
    includes(user: [rep: [:party]])
  end
end
