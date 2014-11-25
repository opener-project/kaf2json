#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/kaf_to_json'

daemon = Opener::Daemons::Daemon.new(Opener::KafToJson)

daemon.start
