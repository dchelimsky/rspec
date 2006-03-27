require 'test/unit'
require File.dirname(__FILE__) + '/context'

class MockBuilder
  attr_reader :name_received, :error_received
  def add_spec_result(name, error=nil)
    @name_received = name
    @error_received = error
  end
end

class SpecificationTest < Test::Unit::TestCase

  def test_should_hold_exception
    @spec = Spec::Specification.new("test") { raise }
    @spec.run(nil, nil)
    assert(@spec.failed?)
    assert_not_nil(@spec.exception)
  end
  
  def test_should_not_have_an_exception_if_passes
    @spec = Spec::Specification.new("test") { true }
    @spec.run(nil, nil)
    assert(!@spec.failed?)
    assert_nil(@spec.exception)
  end
  
  def test_should_add_its_name_to_builder
    @spec = Spec::Specification.new("builder test") { true }
    builder = MockBuilder.new
    @spec.add_to_builder(builder)
    assert_equal(builder.name_received, "builder test")
  end
  
  def test_should_add_its_name_and_exception_to_builder
    @spec = Spec::Specification.new("builder test") { raise }
    @spec.run
    builder = MockBuilder.new
    @spec.add_to_builder(builder)
    assert_equal(builder.name_received, "builder test")
    assert_not_nil(builder.error_received)
  end
  
end