# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  body           :text
#  is_anonymous   :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  votes_count    :integer          default(0)
#  answers_count  :integer          default(0)
#  topic_id       :integer
#  embedded_topic_id   :integer
#  comments_count :integer          default(0), not null
#  user_id        :integer          not null
#

FactoryGirl.define do
  factory :question do
    body { Faker::Lorem.characters(120) }
    user
  end
end
