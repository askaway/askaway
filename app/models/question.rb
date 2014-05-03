# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  body           :text
#  name           :string(255)
#  email          :string(255)
#  is_anonymous   :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :string(255)
#  likes_count    :integer          default(0)
#  answers_count  :integer          default(0)
#  is_featured    :boolean          default(FALSE)
#  comments_count :integer          default(0)
#

class Question < ActiveRecord::Base
  include ERB::Util
  include AASM
  attr_accessible :body, :email, :name, :is_anonymous

  aasm column: "status", whiny_transitions: false do
    state :pending, initial: true
    state :accepted
    state :declined
    state :flagged

    event :accept do
      transitions from: [:pending, :flagged], to: :accepted
    end

    event :decline do
      transitions from: [:pending, :flagged], to: :declined
    end

    event :flag do
      transitions from: [:pending, :accepted], to: :flagged
    end
  end

  has_many :answers, inverse_of: :question

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_numericality_of :likes_count, greater_than_or_equal_to: 0

  after_initialize :init_count
  before_validation :set_init_defaults
  after_create :email_meg

  scope :answered, -> { joins(:answers).order('questions.answers_count DESC') }
  scope :unanswered, -> { where('questions.answers_count < 4') }
  scope :recent, -> { order("questions.created_at DESC") }
  scope :top, -> { order("questions.likes_count DESC") }
  scope :search_scope, ->(query) { where(Question.arel_table[:body].matches("%#{query}%")) }
  scope :ai, -> { accepted.uniq.includes(answers: :candidate) }

  def first_name
    name.split(' ',).first
  end

  def anonymous_name
    if is_anonymous?
      'Anonymous'
    else
      name
    end
  end

  def name_and_email
    "#{h name} <#{h email}>".html_safe
  end

  def label
    id.to_s + " - ".html_safe + body
  end

  def increment
    self.likes_count = self.likes_count + 1
    save
  end

  def decrement
    self.likes_count = self.likes_count - 1
    save
  end

  def needs_voting_reminder?
    answers_count < 3
  end

  def answered?
    answers.any?
  end

  def candidates_with_no_answer
    Candidate.all-answers.map(&:candidate)
  end

  private

  def init_count
    likes_count ||= 0
  end

  def set_init_defaults
    self.status ||= "accepted"
  end

  def email_meg
    QuestionMailer.question_asked(self).deliver
  end
end
