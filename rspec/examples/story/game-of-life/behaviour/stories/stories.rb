dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("#{dir}/../../../../../../rspec/lib"))
require 'spec'
$LOAD_PATH.unshift(File.expand_path("#{dir}/../../"))
require "#{dir}/../../life"
require 'behaviour/stories/create_a_cell'
require 'behaviour/stories/kill_a_cell'
