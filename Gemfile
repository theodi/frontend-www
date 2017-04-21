source 'https://rubygems.org'

ruby "1.9.3"

gem 'rake', '< 11.0'
gem 'rails', '~> 3.2.14'
gem 'dotenv-rails'

gem 'foreman', '< 0.65.0'
gem 'puma'

gem 'rack-google-analytics'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'statsd-ruby', '1.0.0', :require => 'statsd'

gem 'plek', '1.5.0'
gem 'gds-api-adapters', :github => 'theodi/gds-api-adapters'
gem 'slimmer', '~> 8.4.0'

gem 'juvia_rails', github: 'theodi/juvia_rails'
gem 'alternate_rails', github: 'theodi/alternate-rails'

gem 'countries'

gem 'content_for_in_controllers'

gem 'jbuilder'

gem 'font-awesome-rails'

# Handle bad UTF8 strings
gem 'utf8-cleaner'

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
  gem 'rails_12factor'
end

group :test do
  gem 'simplecov-rcov'
  gem 'webmock'
  gem 'mocha', :require => false
  gem 'pry'
  gem 'timecop'
  gem 'coveralls', :require => false
  gem 'vcr'
  gem 'rspec-rails'
end

group :development, :test do
  gem 'sqlite3'
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
gem "gibbon", "~> 1.2.1" # Pinned to 1.2.1, 2.0.0 requires Ruby >= 2.0.0
gem 'metamagic'
