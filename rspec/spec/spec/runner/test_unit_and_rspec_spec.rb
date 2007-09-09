require File.dirname(__FILE__) + '/../../spec_helper.rb'

class TestUnitAndRspecSpec < ::Spec::DSL::Example
  class << self
    attr_accessor :examples_run
  end
  
  it "should run tests and specs" do
    self.class.examples_run = true
  end
end

class TestUnitAndRspecTest < Test::Unit::TestCase
  def test_should_run_tests
    assert TestUnitAndRspecSpec.examples_run
  end
end
