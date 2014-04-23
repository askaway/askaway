# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.characters(120) }
    candidate
    question
  end
end
