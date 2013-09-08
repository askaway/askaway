class Question < ActiveRecord::Base
  STATUSES = %w(pending accepted declined)
  attr_accessible :body, :email, :name, :is_anonymous

  has_many :answers

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_inclusion_of :status, in: STATUSES

  before_validation :set_init_defaults

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
    "#{name} <#{email}>"
  end

  def pending?
    status == 'pending'
  end

  private

  def set_init_defaults
    self.status ||= "pending"
  end
end
