require_relative '../../lib/opener/kaf_to_json'
require 'rspec/expectations'
require 'tempfile'

def kernel_root
  File.expand_path("../../../", __FILE__)
end

def kernel
  return Opener::KafToJson.new
end
