source 'https://rubygems.org'

ruby "1.9.3"

gem 'rake', '< 12.0'
gem 'rails', '~> 3.2.22'
gem 'dotenv-rails'

gem 'foreman', '< 0.84.0'
gem 'puma'

gem 'rack-google-analytics'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'statsd-ruby', '1.4.0', :require => 'statsd'

gem 'plek', '2.0.0'
gem 'gds-api-adapters', git: 'https://github.com/theodi/gds-api-adapters.git', ref: "d1c4ce05b00dc71712b93502c7df43362ca9671e"
gem 'slimmer', '~> 8.4.0'

gem 'juvia_rails', git: 'https://github.com/theodi/juvia_rails.git', ref: "0e6dd7d597f10ad9174fb0c08de635a5f0063777"
gem 'alternate_rails', git: 'https://github.com/theodi/alternate-rails.git', ref: "83a5b8b73655283b2d9729eeae848488881eecc4"

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

  gem 'uglifier', '>= 3.2.0'
end

gem 'odlifier', git: 'https://github.com/theodi/odlifier.git', ref: "b3940e0cda805ccb502b5a87d0a3bbfdc93ed032"

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
