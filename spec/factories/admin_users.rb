# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user do
    email {  Faker::Internet.email }
    password "secret more than 8"
  end
end
