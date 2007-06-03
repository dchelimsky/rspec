dir = File.dirname(__FILE__)
require 'application'

silence_warnings { RAILS_ENV = "test" }
require 'action_controller/test_process'
require 'action_controller/integration'
require 'active_record/base'
require 'active_record/fixtures'
require 'spec'

require File.expand_path("#{dir}/rails/dsl")

require File.expand_path("#{dir}/dsl")
require File.expand_path("#{dir}/matchers")

require File.expand_path("#{dir}/rails/version")
require File.expand_path("#{dir}/rails/extensions")
require File.expand_path("#{dir}/rails/matchers")

Test::Unit.run = true

module Spec
  # = Spec::Rails
  #
  # Spec::Rails (a.k.a. RSpec on Rails) is a Ruby on Rails plugin that allows you to drive the development
  # of your RoR application using RSpec, a framework that aims to enable Behaviour Driven Development
  # in Ruby.
  # 
  # == Features
  # 
  # * Use RSpec to independently specify Rails Models, Views, Controllers and Helpers
  # * Integrated fixture loading
  # * Special generators for Resources, Models, Views and Controllers that generate Specs instead of Tests.
  # 
  # == Vision
  # 
  # For people for whom TDD is a brand new concept, the testing support built into Ruby on Rails
  # is a huge leap forward. The fact that it is built right in is fantastic, and Ruby on Rails
  # apps are generally much easier to maintain than they might have been without such support.
  # 
  # For those of us coming from a history with TDD, and now BDD, the existing support presents some problems related to dependencies across specs. To that end, RSpec on Rails supports 4 types of specs. We’ve also built in first class mocking and stubbing support in order to break dependencies across these different concerns.
  # 
  # == More Information
  #
  # See Spec::Rails::Runner for information about the different kinds of contexts
  # you can use to spec the different Rails components
  # 
  # See Spec::Rails::Expectations for information about Rails-specific expectations
  # you can set on responses and models, etc.
  #
  # == License
  # 
  # RSpec on Rails is licensed under the same license as RSpec itself,
  # the MIT-LICENSE.
  module Rails
  end
end
