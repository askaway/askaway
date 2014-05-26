# == Schema Information
#
# Table name: candidates
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  email         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  authorisation :string(255)
#  avatar        :string(255)
#

class Candidate < ActiveRecord::Base

  has_many :answers
  has_many :questions, through: :answers
end
