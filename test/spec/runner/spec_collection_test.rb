require 'test/unit'

require 'spec'


class Foobar < Spec::Context

  def first_method
  end
  
  def second_method
  end
  
end


class SpecCollectionTest < Test::Unit::TestCase

  def setup
    @collection = Foobar.collection
  end

  def test_should_have_two_fixtures_in_collection
    assert_equal 2, @collection.length 
  end
  
  def test_should_include_first_method_fixture
    assert_equal true, @collection.any? do |spec|
      spec.instance_variable_get(:@specification) == :first_method
    end
  end
  
  def test_should_include_second_method_fixture
    assert_equal true, @collection.any? do |spec|
      spec.instance_variable_get(:@specification) == :second_method
    end
  end

end
