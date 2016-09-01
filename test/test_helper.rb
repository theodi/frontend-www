require 'simplecov'
require 'simplecov-rcov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails'

Coveralls.wear!

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test/unit'
require 'mocha/setup'
require 'webmock/test_unit'
require 'timecop'
require 'vcr'

WebMock.disable_net_connect!(:allow_localhost => true)

require 'gds_api/test_helpers/content_api'

VCR.configure do |c|
  # Automatically filter all secure details that are stored in the environment
  ignore_env = %w{SHLVL RUNLEVEL GUARD_NOTIFY DRB COLUMNS USER LOGNAME LINES TERM_PROGRAM_VERSION}
  (ENV.keys-ignore_env).select{|x| x =~ /\A[A-Z_]*\Z/}.each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
  c.cassette_library_dir = 'test/fixtures/cassettes'
  c.default_cassette_options = { :record => :once }
  c.hook_into :webmock
  c.ignore_hosts 'bd7a65e2cb448908f934-86a50c88e47af9e1fb58ce0672b5a500.r32.cf3.rackcdn.com'
end

class ActiveSupport::TestCase
  include GdsApi::TestHelpers::ContentApi
end

def load_fixture(filename)
  File.read File.join(Rails.root, 'test', 'fixtures', filename)
end
