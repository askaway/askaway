class Question < ActiveRecord::Base
  attr_accessible :body, :email, :name, :is_anonymous

  validates_presence_of :body, :email, :name
  validates_length_of :body, maximum: 140
end
