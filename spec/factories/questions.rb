# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  body           :text
#  name           :string(255)
#  email          :string(255)
#  is_anonymous   :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  vote_count     :integer          default(0)
#  answers_count  :integer          default(0)
#  topic_id       :integer
#  comments_count :integer          default(0), not null
#

FactoryGirl.define do
  factory :question do
    body { Faker::Lorem.characters(120) }
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
