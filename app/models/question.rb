class Question < ActiveRecord::Base
  attr_accessible :body, :email, :name, :is_anonymous

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
  validates_inclusion_of :status, in: %w(pending accepted declined)

  before_validation :set_init_defaults


  private

  def set_init_defaults
    self.status ||= "pending"
  end
end
