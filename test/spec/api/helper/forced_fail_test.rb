require File.dirname(__FILE__) + '/../../../test_helper'

class ForcedFailTest < Test::Unit::TestCase

  # violated
  
  def test_violated_should_raise
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      c = Spec::Context.new
      c.violated "boo"
    end
  end
  
end
