require File.dirname(__FILE__)  + '/../lib/spec'
require 'test/unit'

class RspecIntegrationTest < Test::Unit::TestCase
  def self.fixtures(*args)
    @@fixtures = true
  end
  
  def self.verify_class_method
    @@fixtures.should_be true
  end
  
  def setup
    @test_case_setup_called = true
  end

  def teardown
    @test_case_teardown_called = true
  end

  def run(result)
  end

  def helper_method
    @helper_method_called = true
  end
end

module RandomHelperModule
  def random_task
    @random_task_called = true
  end
end

context "Rspec should integrate with Test::Unit::TestCase" do
  inherit RspecIntegrationTest
  include RandomHelperModule

  fixtures :some_table

  setup do
    @rspec_setup_called = true
  end

  specify "TestCase#setup should be called." do
    @test_case_setup_called.should_be true
    @rspec_setup_called.should_be true
  end

  specify "Rspec should be able to access TestCase methods" do
    helper_method
    @helper_method_called.should_be true
  end

  specify "Rspec should be able to accept included modules" do
    random_task
    @random_task_called.should_be true
  end
  
  teardown do
    RspecIntegrationTest.verify_class_method
  end
end
