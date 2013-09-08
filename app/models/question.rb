class Question < ActiveRecord::Base
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

  has_many :answers

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140

  before_validation :set_init_defaults

  scope :answered, -> { joins(:answers) }

  scope :recent, -> { order("created_at DESC") }

  def first_name
    name.split(' ',).first
  end

  def name_and_email
    "#{name} <#{email}>"
  end

  private

  def set_init_defaults
    self.status ||= "pending"
  end
end
