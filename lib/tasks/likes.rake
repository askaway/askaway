require 'net/http'
require 'json'

namespace :likes do
  desc "Refresh like counts from Facebook"
  task :refresh, [:host] => [:environment] do |t, args|
    include ActionDispatch::Routing::UrlFor
    include Rails.application.routes.url_helpers

    host = args[:host] || "example.com"

    default_url_options[:host] = host

    query_string = "SELECT url, total_count FROM link_stat WHERE url IN ( "
    Question.all.each do |q|
      query_string += "'#{url_for(q)}',"
    end
    query_string.chomp!(",")
    query_string += ")"

    uri = URI('https://graph.facebook.com/fql')
    uri.query = URI.encode_www_form({ q: query_string })

    puts uri

    result = Net::HTTP.get_response(uri)

    if not result.is_a?(Net::HTTPSuccess)
      puts "Couldn't refresh the like count"
      puts result.body
      return
    end

    puts result.body
    j = JSON.parse(result.body)

    j["data"].each do |r|
      question_id = r["url"].match('questions/(\d+)')[1]
      q = Question.find(question_id)
      q.likes_count = r["total_count"]
      q.save
    end
  end
end