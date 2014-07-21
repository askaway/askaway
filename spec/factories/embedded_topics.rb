# == Schema Information
#
# Table name: embedded_topics
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :embedded_topic do
    name { Faker::Name.name }
  end
end
