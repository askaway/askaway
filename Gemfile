source 'https://rubygems.org'

gem 'rails', '4.0.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'jquery-ui-rails'
gem 'rack-canonical-host'

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails', '~> 4.0.3'
gem 'coffee-rails', '~> 4.0.1'
gem 'bootstrap-sass', '~> 2.3.2.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.0.3'


gem 'jquery-rails'
gem 'haml'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'aasm'

gem 'kaminari'  # pagination
gem 'share_counts', github: 'fourseven/share_counts' # counting shares
#gem 'derp', "1.0.2"

group :development do
  gem 'thin' # Webrick can't handle chunked responses
  gem 'quiet_assets'
  gem 'debugger', :platforms => [:mingw_19, :ruby_19]
  gem 'byebug', :platforms => [:mingw_20, :ruby_20]
  gem 'pry-byebug', :platforms => [:mingw_20, :ruby_20]
  gem 'guard-rspec'
  gem 'annotate'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'capybara'
  gem 'poltergeist'
  gem 'faker'
  gem 'factory_girl_rails', '~> 4.4.0'
  gem 'launchy'
  gem 'pry-rails'
end

group :test do
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end
