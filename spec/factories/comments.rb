# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  question_id :integer
#  user_id     :integer
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    user
    question
  end
end
