# == Schema Information
#
# Table name: invitations
#
#  id             :integer          not null, primary key
#  email          :string(255)
#  name           :string(255)
#  inviter_id     :string(255)
#  intent         :string(255)
#  invitable_id   :integer
#  invitable_type :string(255)
#  acceptor_id    :integer
#  accepted_at    :datetime
#  token          :string(255)      not null
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    intent "to_join_party"
    inviter
    invitable

    factory :invitation_with_token do
      token { SecureRandom.urlsafe_base64 }
    end
  end
end
