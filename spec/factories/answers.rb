# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  body         :text
#  candidate_id :integer
#  question_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.characters(120) }
    candidate
    question
  end
end
