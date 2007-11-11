require File.dirname(__FILE__) + '/spec_helper.rb'
require 'spec/test'

class TestUnitAndRspecTest < Test::Unit::TestCase
  class << self
    attr_accessor :tests_run
  end

  def test_should_run_tests
    self.class.tests_run = true
    assert true
  end
end

class TestUnitAndRspecSpec < ::Spec::ExampleGroup
  class << self
    attr_accessor :examples_run
  end

  it "should run tests and specs" do
    TestUnitAndRspecTest.suite.run(Test::Unit::TestResult.new) {}
    TestUnitAndRspecTest.tests_run.should be_true
  end

  def test_should_have_seamless_transition_from_test_unit
    assert true
  end
end
