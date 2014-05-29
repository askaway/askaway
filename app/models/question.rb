# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  body           :text
#  is_anonymous   :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  vote_count     :integer          default(0)
#  answers_count  :integer          default(0)
#  topic_id       :integer
#  comments_count :integer          default(0), not null
#  user_id        :integer          not null
#

class Question < ActiveRecord::Base
  has_many :answers, inverse_of: :question
  has_many :comments, inverse_of: :question
  belongs_to :topic
  belongs_to :user

  validates_presence_of :body, :topic, :user
  validates_length_of :body, maximum: 140
  validates_numericality_of :vote_count, greater_than_or_equal_to: 0

  before_validation :init_topic

  scope :answered, -> { joins(:answers).order('questions.answers_count DESC') }
  scope :unanswered, -> { where('questions.answers_count < 4') }
  scope :top, -> { order("questions.vote_count DESC") }

  def user_name
    if is_anonymous?
      'Anonymous'
    else
      user.name
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
