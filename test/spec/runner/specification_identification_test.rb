require 'test/unit'

require 'spec'


class SpecificationIdentificationContext < Spec::Context

  def setup
  end
  
  def teardown
  end
  
  def foo
  end

  def bar
  end
  
  def baz(arg1, arg2)
  end
  
  def _method_with_underscore
  end

end


class ContextTest < Test::Unit::TestCase

  def setup
    @spec_id_context = SpecificationIdentificationContext.new
  end
  
  def test_should_inherit_from_context
    assert_equal Spec::Context, @spec_id_context.class.superclass
  end
  
  def test_should_contain_two_specifications
    assert_equal 2, SpecificationIdentificationContext.specifications.length
  end
  
  def test_should_have_foo_specification
    assert_equal true, SpecificationIdentificationContext.specifications.include?('foo')
  end
  
  def test_should_have_bar_specification
    assert_equal true, SpecificationIdentificationContext.specifications.include?('bar')
  end
  
  def test_should_not_include_specifications_method_in_specifications
    assert_equal false, SpecificationIdentificationContext.specifications.include?('specifications')
  end
  
  def test_should_not_include_setup_in_specifications
    assert_equal false, SpecificationIdentificationContext.specifications.include?(:setup)
  end
  
  def test_should_not_include_teardown_in_specifications
    assert_equal false, SpecificationIdentificationContext.specifications.include?(:teardown)
  end
  
  def test_should_not_include_methods_with_args_in_specifications
    assert_equal false, SpecificationIdentificationContext.specifications.include?('baz')
  end
  
  def test_should_not_include_methods_prefixed_with_underscore_in_specifications
    assert_equal false, SpecificationIdentificationContext.specifications.include?('_method_with_underscore')
  end

end
