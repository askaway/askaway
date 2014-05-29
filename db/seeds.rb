# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

candidates = [
  {
    name: 'Celia Wade-Brown',
    email: '',
    authorisation: 'Authorised by Celia Wade-Brown of 101 Wakefield Street, Wellington',
  },
  {
    name: 'Jack Yan',
    email: '',
    authorisation: 'Authorised by C. Johnston of 35-8 Cambridge Terrace, Wellington 6011',
  },
  {
    name: 'John Morrison',
    email: '',
    authorisation: 'Authorised by John Morrison, Level 5, 93 Boulcott Street, Wellington',
  },
  {
    name: 'Karunanidhi Muthu',
    email: '',
    authorisation: 'Authorised by Karunanidhi Muthu of Suite 239, 32 Salamanca Road, Kelburn, Wellington 6012',
  },
  {
    name: 'Nicola Young',
    email: '',
    authorisation: 'Authorised by Nicola Young of B44/10 Ebor Street, Te Aro, Wellington 6011',
  },
  {
    name: 'Rob Goulden',
    email: '',
    authorisation: 'Authorised by Rob Goulden, 14 Kauri Street, Miramar, Wellington',
  }
]


def create_or_update_candidate( details = {} )
  name          = details[:name]
  email         = details[:email]
  authorisation = details[:authorisation]
  avatar        = details[:name].gsub(' ','-') + '.png'
  if c = Candidate.find_by_name(name)
    c.update_attributes(email: email, authorisation: authorisation, avatar: avatar)
  else
    c = Candidate.create(name: name, email: email, authorisation: authorisation, avatar: avatar)
  end
  p c
end

candidates.each do |candidate_details|
  create_or_update_candidate( candidate_details )
end


general_topic = FactoryGirl.create(:topic, name: "General")

FactoryGirl.define do
  factory :seed_question, class: Question do
    body { "How will you #{Faker::Company.bs.split[0]} the role of #{Faker::Name.title.split[0..1].join(' ')} to make Wellington a more #{Faker::Commerce.fetch('commerce.product_name.adjective').downcase} place?" }
    user
    topic general_topic
  end
  # factory :seed_answer, class: Answer do
  #   body { "By importing more #{Faker::Commerce.product_name.pluralize(10)}" }
  # end
end

require "rspec/mocks/standalone"
Question.any_instance.stub(:set_initial_state)


100.times do |i|
  FactoryGirl.create(:seed_question)
end

Question.all.each do |question|
  if question.answers.blank? && Random.rand < 0.7
    puts "Creating answers"
    Random.rand(6).times do |i|
      question.answers.create! do |answer|
        answer.body = "By importing more #{Faker::Commerce.product_name.pluralize(10)}"
        answer.candidate_id = (i + 1)

        #answer.body = answer.body.to_derp if answer.candidate_id == 3
      end
    end
  else
    puts "No questions found"
  end
end

if User.create(name: 'Admin User', email: 'admin@example.com', password: 'password', is_admin: true)
  puts 'Created admin user. email: admin@example.com, password: password'
end
