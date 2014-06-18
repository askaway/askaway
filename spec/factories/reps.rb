# == Schema Information
#
# Table name: reps
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  party_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rep do
    user
    party
  end
end
