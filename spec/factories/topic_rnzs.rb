# == Schema Information
#
# Table name: topic_rnzs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :topic_rnz do
    name { Faker::Name.name }
  end
end
