#!/usr/bin/env ruby

require 'opener/daemons'
require_relative '../lib/opener/kaf_to_json'

options = Opener::Daemons::OptParser.parse!(ARGV)
daemon  = Opener::Daemons::Daemon.new(Opener::KafToJson, options)

daemon.start