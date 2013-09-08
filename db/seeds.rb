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
    authorisation: 'Authorised by C. Johnston of 35–8 Cambridge Terrace, Wellington 6011',
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
