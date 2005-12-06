require 'spec'

class AddToMeSpec < Spec::Context

  def foo
  end

end

class SpecificationAdditionTest < Test::Unit::TestCase

  def test_should_add_specification
    AddToMeSpec.add_specification(:bar) { true.should_equal true }
    
    assert_equal true, AddToMeSpec.specifications.include?('bar')
  end

end
