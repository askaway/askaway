class Question < ActiveRecord::Base
  STATUSES = %w(pending accepted declined)
  attr_accessible :body, :email, :name, :is_anonymous

  has_many :answers

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_inclusion_of :status, in: STATUSES

  before_validation :set_init_defaults

  def self.accepted
    where(status: :accepted)
  end

  def first_name
    name.split(' ',).first
  end

  private

  def set_init_defaults
    self.status ||= "pending"
  end
end
