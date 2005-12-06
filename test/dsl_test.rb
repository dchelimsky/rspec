require 'test/unit'

require 'spec'

class DSLTest < Test::Unit::TestCase
  
  def test_should_have_specification_method_defined
    assert_equal true, Object.public_method_defined?(:specification)
  end

end
