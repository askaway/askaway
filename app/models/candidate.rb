# == Schema Information
#
# Table name: candidates
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  email         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  authorisation :string(255)
#  avatar        :string(255)
#

class Candidate < ActiveRecord::Base
  attr_accessible :name, :email, :avatar, :authorisation

  has_many :answers
  has_many :questions, through: :answers
end
