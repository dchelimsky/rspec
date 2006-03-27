require File.dirname(__FILE__) + '/../../../test_helper'

class EqualityTest < Test::Unit::TestCase

  def setup
    @dummy = 'dummy'
    @equal_dummy = 'dummy'
    @another_dummy  = 'another_dummy'
    @nil_var = nil
  end

  # should.equal
  
  def test_should_equal_should_not_raise_when_objects_are_equal
    assert_nothing_raised do
      @dummy.should.equal @equal_dummy
    end
  end
  
  def test_should_equal_should_raise_when_objects_are_not_equal
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should.equal @another_dummy
    end
  end

  # should.not.equal

  def test_should_not_equal_should_not_raise_when_objects_are_not_equal
    assert_nothing_raised do
      @dummy.should.not.equal @another_dummy
    end
  end

  def test_should_not_equal_should_raise_when_objects_are_not_equal
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should.not.equal @equal_dummy
    end
  end

end
