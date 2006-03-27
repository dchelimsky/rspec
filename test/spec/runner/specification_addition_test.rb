require 'test/unit'

require 'spec'


class AddToMe < Spec::Context
  
  def orig_spec
    true.should_equal true
  end
  
end


class SpecificationAdditionTest < Test::Unit::TestCase

  def test_should_add_foo_specification_to_context
    AddToMe.add_specification(:added_spec) { false.should_equal false }
    
    assert_equal true, AddToMe.specifications.include?('added_spec')
  end
  
  def test_should_add_another_specification_to_context
    AddToMe.add_specification(:another_added_spec) { true.should_equal false }
    
    assert_equal true, AddToMe.specifications.include?('another_added_spec')
  end
  
end
