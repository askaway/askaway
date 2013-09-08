class Question < ActiveRecord::Base
  # include ActiveSupport::Helpers
  include ERB::Util

  STATUSES = %w(pending accepted declined)
  attr_accessible :body, :email, :name, :is_anonymous

  has_many :answers

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_inclusion_of :status, in: STATUSES

  before_validation :set_init_defaults
  after_create :email_meg

  scope :accepted, -> { where(status: :accepted) }

  scope :answered, -> { joins(:answers) }

  scope :recent, -> { order("created_at DESC") }

  def accept!
    unless accepted?
      update_attribute(:status, 'accepted')
      QuestionMailer.question_accepted(self).deliver
    end
  end

  def accepted?
    status == 'accepted'
  end

  def first_name
    name.split(' ',).first
  end

  def name_and_email
    "#{h name} <#{h email}>".html_safe
  end

  def pending?
    status == 'pending'
  end

  private

  def set_init_defaults
    self.status ||= "pending"
  end

  def email_meg
    QuestionMailer.question_asked(self).deliver
  end
end
