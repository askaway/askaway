# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  body         :text
#  rep_id :integer
#  question_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    rep
    question
    body { Faker::Lorem.characters(120) }
  end
end
