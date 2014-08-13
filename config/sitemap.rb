# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://nzelection.askaway.org.nz/"

SitemapGenerator::Sitemap.create do
  add new_questions_path,  priority: 1, changefreq: 'always'
  add trending_path,       priority: 1, changefreq: 'always'
  add most_votes_path,     priority: 1, changefreq: 'always'

  Question.find_each do |question|
    add question_path(question), priority: 0.9, changefreq: 'daily'
  end

  Party.find_each do |party|
    add party_path(party), priority: 0.8, changefreq: 'daily'
  end

  User.find_each do |user|
    add user_path(user), priority: 0.6
  end

  add about_path,           priority: 0.5
  add terms_of_use_path,    priority: 0.5
  add privacy_policy_path,  priority: 0.5
end
