class Candidate < ActiveRecord::Base
  attr_accessible :name, :email, :avatar, :authorisation

  has_many :answers
  has_many :questions, through: :answers
end
