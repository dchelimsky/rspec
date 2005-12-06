require 'test/unit'

require 'spec'

class AddToMeSpec < Spec::Context

  def foo
  end

end

class DSLTest < Test::Unit::TestCase
  
  def test_should_have_specification_method_defined
    assert_equal true, Object.public_method_defined?(:specification)
  end

  def test_should_add_specification
    AddToMeSpec.add_specification(:bar) { true.should_equal true }

    assert_equal true, AddToMeSpec.specifications.include?('bar')
  end
  
end
