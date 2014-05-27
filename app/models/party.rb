# == Schema Information
#
# Table name: parties
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  auth_statement :string(255)
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Party < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :auth_statement
end
