# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    email { Faker::Internet.email }
    intent "to_join_group"
    inviter
    invitable

    factory :invitation_with_token do
      token { SecureRandom.urlsafe_base64 }
    end
  end
end
