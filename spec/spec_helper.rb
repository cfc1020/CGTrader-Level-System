require 'rubygems'
require 'bundler/setup'

require 'support/init_database'
require 'support/database_cleaner'

require 'simplecov'
SimpleCov.start

require "shoulda/matchers"

require 'cgtrader_levels'

RSpec.configure { |config| }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
  end
end
