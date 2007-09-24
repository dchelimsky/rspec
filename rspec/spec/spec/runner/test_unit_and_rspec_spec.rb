require File.dirname(__FILE__) + '/../../spec_helper.rb'

class TestUnitAndRspecSpec < ::Spec::DSL::Example
  class << self
    attr_accessor :examples_run
  end
  
  it "should run tests and specs" do
    self.class.examples_run = true
  end

  def test_should_have_seamless_transition_from_test_unit
    assert true
  end
end

class TestUnitAndRspecTest < Test::Unit::TestCase
  def test_should_run_tests
    assert TestUnitAndRspecSpec.examples_run
  end
end
