class Question < ActiveRecord::Base
  include ERB::Util
  include AASM
  attr_accessible :body, :email, :name, :is_anonymous

  aasm column: "status", whiny_transitions: false do
    state :pending, initial: true
    state :accepted
    state :declined

    event :accept do
      after do
        QuestionMailer.question_accepted(self).deliver
      end

      transitions from: :pending, to: :accepted
    end

    event :decline do
      transitions from: :pending, to: :declined
    end
  end

  has_many :answers, inverse_of: :question

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_numericality_of :likes_count, greater_than_or_equal_to: 0

  after_initialize :init_count
  before_validation :set_init_defaults
  after_create :email_meg

  scope :answered, -> { joins(:answers) }
  scope :unanswered, -> { joins('LEFT OUTER JOIN answers ON questions.id = answers.question_id').where('answers.question_id IS NULL') }
  scope :recent, -> { order("questions.updated_at DESC") }
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
    self.status ||= "pending"
  end

  def email_meg
    QuestionMailer.question_asked(self).deliver
  end
end
