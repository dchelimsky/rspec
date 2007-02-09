dir = File.dirname(__FILE__)
require 'application'

silence_warnings { RAILS_ENV = "test" }
require 'action_controller/test_process'
require 'action_controller/integration'
require 'active_record/base'
require 'active_record/fixtures'
require 'spec'


require File.expand_path("#{dir}/rails/version")
require File.expand_path("#{dir}/rails/runner")
require File.expand_path("#{dir}/rails/extensions")
require File.expand_path("#{dir}/rails/expectations")


Test::Unit.run = true
