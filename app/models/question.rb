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
#  status         :string(255)
#  vote_count    :integer          default(0)
#  answers_count :integer          default(0)
#

class Question < ActiveRecord::Base
  include AASM
  # FIXME does adding status here mean *anyone* can add it? As in,
  # will rails just let people smash in whatever they like?
  # TODO do I still need this?
  # attr_accessible :body, :email, :name, :status, :is_anonymous

  aasm column: "status" do
    state :default, initial: true
    state :approved
    state :declined
    state :flagged

    event :approve do
      transitions from: [:default, :flagged], to: :approved
    end

    event :decline do
      transitions from: [:default, :flagged], to: :declined
    end

    event :flag do
      transitions from: [:default, :approved], to: :flagged
    end
  end

  has_many :answers, inverse_of: :question

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_numericality_of :vote_count, greater_than_or_equal_to: 0

  after_initialize :init_vote_count

  scope :answered, -> { joins(:answers).order('questions.answers_count DESC') }
  scope :unanswered, -> { where('questions.answers_count < 4') }
  scope :top, -> { order("questions.vote_count DESC") }

  # for reference
  #scope :ai, -> { where(status: [:default, :approved]).uniq.includes(answers: :candidate) }

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
