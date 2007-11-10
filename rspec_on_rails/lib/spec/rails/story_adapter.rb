# WARNING - THIS IS PURELY EXPERIMENTAL AT THIS POINT
# Courtesy of Brian Takita and Yurii Rashkovskii

$:.unshift File.join(File.dirname(__FILE__), *%w[.. .. .. .. rspec lib])
require 'test_help'
require 'test/unit/testresult'
require 'spec'
require 'spec/rails'

Test::Unit.run = true

class RailsStory < ActionController::IntegrationTest
  self.use_transactional_fixtures = true
  include Spec::Rails::Matchers

  def initialize #:nodoc:
    @_result = Test::Unit::TestResult.new
  end
end

class ActiveRecordSafetyListener
  include Singleton
  def scenario_started(*args)
    ActiveRecord::Base.send :increment_open_transactions unless Rails::VERSION::STRING == "1.1.6"
    ActiveRecord::Base.connection.begin_db_transaction
  end
  def scenario_succeeded(*args)
    ActiveRecord::Base.connection.rollback_db_transaction
    ActiveRecord::Base.send :decrement_open_transactions unless Rails::VERSION::STRING == "1.1.6"
  end
  alias :scenario_pending :scenario_succeeded
  alias :scenario_failed :scenario_succeeded
end

class Spec::Story::Runner::ScenarioRunner
  def initialize
    @listeners = [ActiveRecordSafetyListener.instance]
  end
end

class Spec::Story::GivenScenario
  def perform(instance)
    scenario = Spec::Story::Runner::StoryRunner.scenario_from_current_story @name
    runner = Spec::Story::Runner::ScenarioRunner.new
    runner.instance_variable_set(:@listeners,[])
    runner.run(scenario, instance)
  end
end
