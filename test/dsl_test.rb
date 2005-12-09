require 'test/unit'

require 'spec'

class DSLTest < Test::Unit::TestCase
  
  def setup
    $default_context = nil
    $current_context = nil
  end
  
  def test_should_have_specification_method_defined
    assert_equal true, Object.public_method_defined?(:specification)
  end
  
  def test_should_add_specification_to_default_context
    specification('foobar') { true.should_equal true }
    
    assert_equal true, $default_context.specifications.include?('foobar')
  end
  
  def test_should_create_new_context
    context 'my_context'
    
    assert_equal Spec::Context, $my_context.superclass
  end
  
  def test_should_set_current_context_to_new_context
    context 'bar'
    
    assert_equal $current_context, $bar
  end
  
  def test_should_add_bar_specification_to_foo_context
    context 'foo'
    specification('bar') { true.should_equal true }
    
    assert_equal true, $foo.specifications.include?('bar')
  end
  
  def test_should_add_bar_specification_to_current_context
    context 'foo'
    specification('bar') { true.should_equal true }
    
    assert_equal true, $current_context.specifications.include?('bar')
  end

end
