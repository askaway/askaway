FactoryGirl.define do
  factory :answer do
    candidate
    question
    body { Faker::Lorem.characters(120) }
  end
end
