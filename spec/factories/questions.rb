FactoryGirl.define do
  factory :question do
    body { Faker::Lorem.characters(120) }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    status 'accepted'
  end
end
