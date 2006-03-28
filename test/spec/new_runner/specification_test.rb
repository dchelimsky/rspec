require File.dirname(__FILE__) + '/../../test_helper'

class SpecificationTest < Test::Unit::TestCase
  
  def setup
    @builder = MockBuilder.new
  end  

  def test_should_hold_exception
    @spec = Spec::Specification.new("context", "spec") { raise }
    @spec.run(@builder)
    assert_equal("spec", @builder.failure_name_received)
    assert_not_nil(@builder.error_received)
  end
  
  def test_should_not_have_an_exception_if_passes
    @spec = Spec::Specification.new("context", "spec") { true }
    @spec.run(@builder)
    assert_nil(@builder.failure_name_received)
    assert_nil(@builder.error_received)
  end
  
  def test_should_add_its_name_and_exception_to_builder
    @spec = Spec::Specification.new("context", "builder test") { raise }
    @spec.run(@builder)
    assert_equal("builder test", @builder.failure_name_received)
  end

  def test_should_know_whether_it_passed
    spec = Spec::Specification.new("context","should pass") { true }
    spec.run(@builder)
    assert_equal("should pass", @builder.pass_name_received)
  end
  
  def test_should_run_spec_in_different_scope_than_exception
    spec = Spec::Specification.new("context","should pass") { @exception = RuntimeError.new }
    spec.run(@builder)
    assert_equal("should pass", @builder.pass_name_received)
  end

end