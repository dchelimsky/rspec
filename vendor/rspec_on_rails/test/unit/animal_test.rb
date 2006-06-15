require File.dirname(__FILE__) + '/../test_helper'

class AnimalTest < Test::Unit::TestCase
  fixtures :animals, :people

  def test_should_have_person
    assert_equal people(:lachie), animals(:pig).person
  end
end
