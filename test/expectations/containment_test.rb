require 'test/unit'

require 'spec'

class ContainmentTest < Test::Unit::TestCase

  def setup
    @dummy = 'dummy'
    @equal_dummy = 'dummy'
    @another_dummy  = 'another_dummy'
    @nil_var = nil
  end

  # should_include
  
  def test_should_include_shouldnt_raise_when_string_inclusion_is_present
    assert_nothing_raised do
      @dummy.should.include "mm"
    end
  end
  
  def test_should_include_should_raise_when_string_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should.include "abc" 
    end
  end

  def test_should_include_shouldnt_raise_when_array_inclusion_is_present
    assert_nothing_raised do
      [1, 2, 3].should.include 2
    end
  end

  def test_should_include_should_raise_when_array_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      [1, 2, 3].should.include 5
    end
  end

  def test_should_include_shouldnt_raise_when_hash_inclusion_is_present
    assert_nothing_raised do
      {"a"=>1}.should.include "a"
    end
  end

  def test_should_include_should_raise_when_hash_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      {"a"=>1}.should.include "b"
    end
  end

  def test_should_include_shouldnt_raise_when_enumerable_inclusion_is_present
    assert_nothing_raised do
      IO.constants.should.include "SEEK_SET"
    end
  end

  def test_should_include_should_raise_when_enumerable_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      IO.constants.should.include "BLAH"
    end
  end
  
  # should_not_include
  
  def test_should_not_include_shouldnt_raise_when_string_inclusion_is_missing
    assert_nothing_raised do
      @dummy.should.not.include "abc"
    end
  end

  def test_should_not_include_should_raise_when_string_inclusion_is_present
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should.not.include "mm"
    end
  end

  def test_should_not_include_shouldnt_raise_when_array_inclusion_is_missing
    assert_nothing_raised do
      [1, 2, 3].should.not.include 5
    end
  end

  def test_should_not_include_should_raise_when_array_inclusion_is_present
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      [1, 2, 3].should.not.include 2
    end
  end

  def test_should_not_include_shouldnt_raise_when_hash_inclusion_is_missing
    assert_nothing_raised do
      {"a"=>1}.should.not.include "b"
    end
  end

  def test_should_not_include_should_raise_when_hash_inclusion_is_present
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      {"a"=>1}.should.not.include "a"
    end
  end

  def test_should_not_include_shouldnt_raise_when_enumerable_inclusion_is_present
    assert_nothing_raised do
      IO.constants.should.not.include "BLAH"
    end
  end

  def test_should_not_include_should_raise_when_enumerable_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      IO.constants.should.not.include "SEEK_SET" 
    end
  end
end
