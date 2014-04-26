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
#  status        :string(255)
#  likes_count   :integer          default(0)
#  answers_count :integer          default(0)
#  is_featured   :boolean          default(FALSE)
#

class Question < ActiveRecord::Base
  has_many :answers, inverse_of: :question
  belongs_to :topic

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_numericality_of :vote_count, greater_than_or_equal_to: 0

  after_initialize :init_vote_count

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

  def init_vote_count
    vote_count ||= 0
  end
end
