# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  body          :text
#  name          :string(255)
#  email         :string(255)
#  is_anonymous  :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  vote_count    :integer          default(0)
#  answers_count :integer          default(0)
#  topic_id      :integer
#

class Question < ActiveRecord::Base
  has_many :answers, inverse_of: :question
  belongs_to :topic

  validates_presence_of :body, :email, :name, :topic
  validates_length_of :body, maximum: 140
  validates_numericality_of :vote_count, greater_than_or_equal_to: 0

  before_validation :init_topic

  scope :answered, -> { joins(:answers).order('questions.answers_count DESC') }
  scope :unanswered, -> { where('questions.answers_count < 4') }
  scope :top, -> { order("questions.vote_count DESC") }

  def anonymous_name
    if is_anonymous?
      'Anonymous'
    else
      name
    end
  end

  def answered?
    answers.any?
  end

  private

  def init_topic
    self.topic ||= Topic.find_or_create_by(name: 'General')
  end
end
