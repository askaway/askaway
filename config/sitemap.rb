# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://ENV['CANONICAL_HOST']/"

# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

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
