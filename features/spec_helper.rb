require 'bundler/setup'
require 'rspec'
require 'yaml'

ENV['RACK_ENV'] = 'test'

require_relative '../lib/opener/kaf_to_json'

RSpec.configure do |config|
  config.color = true
end
