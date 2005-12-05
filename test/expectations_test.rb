require 'test/unit'

require 'spec'


class DummyObject

  def initialize(foo)
    @foo = foo
  end

end


class ExpectationsTest < Test::Unit::TestCase

  def setup
    @dummy = 'dummy'
    @equal_dummy = 'dummy'
    @another_dummy  = 'another_dummy'
    @nil_var = nil
  end

  # should
  
  def test_should_raise_exception_when_block_yields_false
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      should do
        false
      end
    end
  end
  
  def test_should_not_raise_exception_when_block_yields_true
    assert_nothing_raised do
      should do
        true
      end
    end
  end

  # should_equal
  
  def test_should_equal_should_not_raise_when_objects_are_equal
    assert_nothing_raised do
      @dummy.should_equal(@equal_dummy)
    end
  end
  
  def test_should_equal_should_raise_when_objects_are_not_equal
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_equal(@another_dummy)
    end
  end

  # should_not_equal

  def test_should_not_equal_should_not_raise_when_objects_are_not_equal
    assert_nothing_raised do
      @dummy.should_not_equal(@another_dummy)
    end
  end

  def test_should_not_equal_should_raise_when_objects_are_not_equal
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_not_equal(@equal_dummy)
    end
  end

  # should_be_same_as

  def test_should_be_same_as_should_not_raise_when_objects_are_same
    assert_nothing_raised do
      @dummy.should_be_same_as(@dummy)
    end
  end

  def test_should_be_same_as_should_raise_when_objects_are_not_same
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_be_same_as(@equal_dummy)
    end
  end

  # should_not_be_same_as

  def test_should_not_be_same_as_should_not_raise_when_objects_are_not_same
    assert_nothing_raised do
      @dummy.should_not_be_same_as(@equal_dummy)
    end
  end

  def test_should_not_be_same_as_should_raise_when_objects_are_not_same
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_not_be_same_as(@dummy)
    end
  end

  # should_match

  def test_should_match_should_not_raise_when_objects_match
    assert_nothing_raised do
      "hi aslak".should_match /aslak/
    end
  end

  def test_should_equal_should_raise_when_objects_do_not_match
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hi aslak".should_match /steve/
    end
  end

  # should_not_match

  def test_should_not_match_should_not_raise_when_objects_do_not_match
    assert_nothing_raised do
      "hi aslak".should_not_match /steve/
    end
  end

  def test_should_not_match_should_raise_when_objects_match
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hi aslak".should_not_match /aslak/
    end
  end

  # should_be_nil

  def test_should_be_nil_should_not_raise_when_object_is_nil
    assert_nothing_raised do
      @nil_var.should_be_nil
    end  
  end

  def test_should_be_nil_should_raise_when_object_is_not_nil
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_be_nil
    end
  end
  
  # should_not_be_nil

  def test_should_not_be_nil_should_not_raise_when_object_is_not_nil
    assert_nothing_raised do
      @dummy.should_not_be_nil
    end  
  end

  def test_should_not_be_nil_should_raise_when_object_is_nil
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @nil_var.should_not_be_nil
    end
  end
      
  # should_be_empty

  def test_should_be_empty_should_raise_when_object_is_not_a_container
    assert_raise(NoMethodError) do
      5.should_be_empty
    end
  end

  def test_should_be_empty_should_raise_when_object_is_a_non_empty_array
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      [1, 2, 3].should_be_empty
    end
  end

  def test_should_be_empty_shouldnt_raise_when_object_is_an_empty_array
    assert_nothing_raised do
      [].should_be_empty
    end
  end

  def test_should_be_empty_should_raise_when_object_is_a_non_empty_hash
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      {"a" => 1}.should_be_empty
    end
  end

  def test_should_be_empty_shouldnt_raise_when_object_is_an_empty_hash
    assert_nothing_raised do
      {}.should_be_empty
    end
  end
  
  # should_not_be_empty

  def test_should_be_empty_should_raise_when_object_is_a_non_empty_string
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_be_empty
    end
  end

  def test_should_be_empty_shouldnt_raise_when_object_is_an_empty_string
    assert_nothing_raised do
      "".should_be_empty
    end
  end

  def test_should_not_be_empty_should_raise_when_object_is_not_a_container
    assert_raise(NoMethodError) do
      5.should_not_be_empty
    end
  end

  def test_should_not_be_empty_should_raise_when_object_is_an_empty_array
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      [].should_not_be_empty
    end
  end

  def test_should_not_be_empty_shouldnt_raise_when_object_is_a_non_empty_array
    assert_nothing_raised do
      [1, 2, 3].should_not_be_empty
    end
  end

  def test_should_not_be_empty_should_raise_when_object_is_an_empty_hash
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      {}.should_not_be_empty
    end
  end

  def test_should_not_be_empty_shouldnt_raise_when_object_is_a_non_empty_hash
    assert_nothing_raised do
      {"a"=>1}.should_not_be_empty
    end
  end

  def test_should_not_be_empty_should_raise_when_object_is_an_empty_string
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "".should_not_be_empty
    end
  end

  def test_should_not_be_empty_shouldnt_raise_when_object_is_a_non_empty_string
    assert_nothing_raised do
      @dummy.should_not_be_empty
    end
  end
  
  # should_include
  
  def test_should_include_shouldnt_raise_when_string_inclusion_is_present
    assert_nothing_raised do
      @dummy.should_include("mm")
    end
  end
  
  def test_should_include_should_raise_when_string_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_include("abc")
    end
  end

  def test_should_include_shouldnt_raise_when_array_inclusion_is_present
    assert_nothing_raised do
      [1, 2, 3].should_include(2)
    end
  end

  def test_should_include_should_raise_when_array_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      [1, 2, 3].should_include(5)
    end
  end

  def test_should_include_shouldnt_raise_when_hash_inclusion_is_present
    assert_nothing_raised do
      {"a"=>1}.should_include("a")
    end
  end

  def test_should_include_should_raise_when_hash_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      {"a"=>1}.should_include("b")
    end
  end

  def test_should_include_shouldnt_raise_when_enumerable_inclusion_is_present
    assert_nothing_raised do
      IO.constants.should_include("SEEK_SET")
    end
  end

  def test_should_include_should_raise_when_enumerable_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      IO.constants.should_include("BLAH")
    end
  end
  
  # should_not_include
  
  def test_should_not_include_shouldnt_raise_when_string_inclusion_is_missing
    assert_nothing_raised do
      @dummy.should_not_include("abc")
    end
  end

  def test_should_not_include_should_raise_when_string_inclusion_is_present
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should_not_include("mm")
    end
  end

  def test_should_not_include_shouldnt_raise_when_array_inclusion_is_missing
    assert_nothing_raised do
      [1, 2, 3].should_not_include(5)
    end
  end

  def test_should_not_include_should_raise_when_array_inclusion_is_present
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      [1, 2, 3].should_not_include(2)
    end
  end

  def test_should_not_include_shouldnt_raise_when_hash_inclusion_is_missing
    assert_nothing_raised do
      {"a"=>1}.should_not_include("b")
    end
  end

  def test_should_not_include_should_raise_when_hash_inclusion_is_present
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      {"a"=>1}.should_not_include("a")
    end
  end

  def test_should_not_include_shouldnt_raise_when_enumerable_inclusion_is_present
    assert_nothing_raised do
      IO.constants.should_not_include("BLAH")
    end
  end

  def test_should_not_include_should_raise_when_enumerable_inclusion_is_missing
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      IO.constants.should_not_include("SEEK_SET")
    end
  end
  
  # violated
  
  def test_violated_should_raise
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      c = Spec::Context.new
      c.violated "boo"
    end
  end
  
  # should_be_true
  
  def test_should_be_true_should_raise_when_object_is_nil
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      nil.should_be_true
    end
  end
  
  def test_should_be_true_should_raise_when_object_is_false
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      false.should_be_true
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_true
    assert_nothing_raised do
      true.should_be_true
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_number
    assert_nothing_raised do
      5.should_be_true
    end
  end
  
  def test_should_be_true_shouldnt_raise_when_object_is_a_string
    assert_nothing_raised do
      "hello".should_be_true
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_some_random_object
    assert_nothing_raised do
      self.should_be_true
    end
  end

  # should_be_false

  def test_should_be_true_shouldnt_raise_when_object_is_nil
    assert_nothing_raised do
      nil.should_be_false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_false
    assert_nothing_raised do
      false.should_be_false
    end
  end

  def test_should_be_true_should_raise_when_object_is_true
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      true.should_be_false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      5.should_be_false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_string
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hello".should_be_false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_some_random_object
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      self.should_be_false
    end
  end

end
