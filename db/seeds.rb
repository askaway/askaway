# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

reps = [
  {
    name: 'Bill English',
    party: 'National Party'
  },
  {
    name: 'Laila Harre',
    party: 'Internet Party'
  },
  {
    name: 'Metiria Turei',
    party: 'Green Party'
  },
  {
    name: 'David Cunliffe',
    party: 'Labour Party'
  }
]

Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/owl.jpg"), "r"))
Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/pukeko.jpg"), "r"))
Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/giraffe.jpg"), "r"))
Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/baboon.jpg"), "r"))
Placeholder.create(uploaded_avatar: File.new(Rails.root.join("app/assets/images/placeholders/fox.jpg"), "r"))
users = []
5.times { users << FactoryGirl.create(:user) }

def create_or_update_rep( details = {} )
  name = details[:name]
  party_name = details[:party]
  unless party = Party.find_by_name(party_name)
    party = FactoryGirl.create(:party, name: party_name)
  end
  unless user = User.find_by_name(name)
    user = FactoryGirl.create(:user, name: name)
  end
  unless party.rep_users.exists?(id: user.id)
    Rep.create(user: user, party: party)
  end
end

reps.each do |rep_details|
  create_or_update_rep( rep_details )
end

def rand_time(from, to=Time.now)
  Time.at(rand_in_range(from.to_f, to.to_f))
end

def rand_in_range(from, to)
  rand * (to - from) + from
end

general_topic = FactoryGirl.create(:topic, name: "General")
values_embedded_topic = FactoryGirl.create(:embedded_topic, name: "Values")
FactoryGirl.create(:embedded_topic, name: "General")
FactoryGirl.create(:embedded_topic, name: "Economy")

FactoryGirl.define do
  factory :seed_question, class: Question do
    body { "How will you #{Faker::Company.bs.split[0]} the role of #{Faker::Name.title.split[0..1].join(' ')} to make New Zealand a more #{Faker::Commerce.fetch('commerce.product_name.adjective').downcase} place?" }
    user { users.sample }
    topic general_topic
    embedded_topic values_embedded_topic
    votes_count { Random.rand(300) }
    created_at { rand_time(1.months.ago) }
  end
  # factory :seed_answer, class: Answer do
  #   body { "By importing more #{Faker::Commerce.product_name.pluralize(10)}" }
  # end
end

require "rspec/mocks/standalone"
Question.any_instance.stub(:set_initial_state)


50.times do |i|
  FactoryGirl.create(:seed_question)
end

Question.all.shuffle.each do |question|
  if question.answers.blank? && Random.rand < 0.7
    puts "Creating answers"
    Random.rand(4).times do |i|
      question.answers.create! do |answer|
        answer.body = "By importing more #{Faker::Commerce.product_name.pluralize(10)}"
        answer.rep_id = (i + 1)

        #answer.body = answer.body.to_derp if answer.rep_id == 3
      end
    end
  else
    puts "No questions found"
  end
end

if User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', is_admin: true)
  puts 'Created admin user. email: admin@example.com, password: password'
end
