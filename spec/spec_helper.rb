require 'rubygems'
require 'bundler/setup'

require 'support/init_database'
require 'support/database_cleaner'

require 'simplecov'
SimpleCov.start

require 'cgtrader_levels'

RSpec.configure { |config| }
