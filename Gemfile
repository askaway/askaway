source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.0.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise'
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'rack-canonical-host'

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails', '~> 4.0.3'
gem 'coffee-rails', '~> 4.0.1'
gem 'bootstrap-sass', '~> 3.1.1.1'
gem 'uglifier', '>= 1.0.3'
gem 'jquery-rails'
gem 'haml'

group :development do
  gem 'thin'
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
  gem 'cucumber-rails', :require => false
end

group :production do
  gem 'pg'
end
