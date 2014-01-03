require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test/unit'
require 'mocha/setup'
require 'webmock/test_unit'
require 'timecop'
WebMock.disable_net_connect!(:allow_localhost => true)

require 'gds_api/test_helpers/content_api'

class ActiveSupport::TestCase
  include GdsApi::TestHelpers::ContentApi
end

def load_fixture(filename)
  File.read File.join(Rails.root, 'test', 'fixtures', filename)
end
