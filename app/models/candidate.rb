class Candidate < ActiveRecord::Base
  has_many :answers
  # attr_accessible :title, :body
end
