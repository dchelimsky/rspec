require File.dirname(__FILE__) + '/../../test_helper'

class SpecificationTest < Test::Unit::TestCase
  
  def setup
    @builder = MockBuilder.new
  end  

  def test_should_hold_exception
    @spec = Spec::Specification.new("test") { raise }
    @spec.run(@builder)
    @spec.add_to_builder(@builder)
    assert_equal("test", @builder.failure_name_received)
    assert_not_nil(@builder.error_received)
  end
  
  def test_should_not_have_an_exception_if_passes
    @spec = Spec::Specification.new("test") { true }
    @spec.run(@builder)
    @spec.add_to_builder(@builder)
    assert_nil(@builder.failure_name_received)
    assert_nil(@builder.error_received)
  end
  
  def test_should_add_its_name_to_builder
    @spec = Spec::Specification.new("builder test") { true }
    @spec.add_to_builder(@builder)
    assert_equal(@builder.spec_name_received, "builder test")
  end
  
  def test_should_add_its_name_and_exception_to_builder
    @spec = Spec::Specification.new("builder test") { raise }
    @spec.run(@builder)
    @spec.add_to_builder(@builder)
    assert_equal(@builder.failure_name_received, "builder test")
  end
  
end