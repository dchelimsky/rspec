require 'test/unit'

require 'spec'

class DSLTest < Test::Unit::TestCase
  
  def test_should_have_specification_method_defined
    assert_equal true, Object.public_method_defined?(:specification)
  end
  
  def test_should_add_specification_to_default_context
    specification('foobar') { true.should_equal true }
    
    assert_equal true, $default_context.specifications.include?('foobar')
  end

end
