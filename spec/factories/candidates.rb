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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :candidate do
  end
end
