require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rspec'
require 'webmock'
require 'vcr'
require 'scrapinghub'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures'
  config.configure_rspec_metadata!
  config.hook_into :webmock
  # allow code coverage reports to be sent to Code Climate
  config.ignore_hosts 'codeclimate.com'
end

RSpec.configure(&:disable_monkey_patching!)
