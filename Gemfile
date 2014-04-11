source 'https://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'

#ruby=ruby-1.9.3
#ruby-gemset=www

gem 'rails', '~> 3.2.14'
gem 'dotenv-rails'

gem 'foreman'
gem 'thin'

gem 'rack-google-analytics', '0.14.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'statsd-ruby', '1.0.0', :require => 'statsd'

gem 'sqlite3'
gem 'plek', '1.5.0'
gem 'gds-api-adapters', :github => 'theodi/gds-api-adapters'
gem 'slimmer'

gem 'juvia_rails', github: 'theodi/juvia_rails'
gem 'alternate_rails', github: 'theodi/alternate-rails'

gem 'countries'

gem 'content_for_in_controllers'

gem 'jbuilder'

gem 'font-awesome-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'odlifier', github: 'theodi/odlifier'

group :production do
  gem 'airbrake'
end

group :test do
  gem 'simplecov-rcov'
  gem 'webmock'
  gem 'mocha', :require => false
  gem 'pry'
  gem 'timecop'
  gem 'coveralls', :require => false
  gem 'vcr'
end

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

gem "newrelic_rpm"
gem "badgerbadgerbadger"
gem "gibbon"
