require File.dirname(__FILE__) + '/../../test_helper'

class SpecificationTest < Test::Unit::TestCase
  
  def setup
    @formatter = MockListener.new
  end  

  def test_should_hold_exception
    @spec = Spec::Specification.new("context", "spec") { raise }
    @spec.run(@formatter)
    assert_equal("spec", @formatter.failure_name_received)
    assert_not_nil(@formatter.error_received)
  end
  
  def test_should_not_have_an_exception_if_passes
    @spec = Spec::Specification.new("context", "spec") { true }
    @spec.run(@formatter)
    assert_nil(@formatter.failure_name_received)
    assert_nil(@formatter.error_received)
  end
  
  def test_should_add_its_name_and_exception_to_builder
    @spec = Spec::Specification.new("context", "builder test") { raise }
    @spec.run(@formatter)
    assert_equal("builder test", @formatter.failure_name_received)
  end

  def test_should_know_whether_it_passed
    spec = Spec::Specification.new("context","should pass") { true }
    spec.run(@formatter)
    assert_equal("should pass", @formatter.pass_name_received)
  end
  
  def test_should_run_spec_in_different_scope_than_exception
    spec = Spec::Specification.new("context","should pass") { @exception = RuntimeError.new }
    spec.run(@formatter)
    assert_equal("should pass", @formatter.pass_name_received)
  end

end