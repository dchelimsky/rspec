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

  # should.satisfy
  
  def test_should_raise_exception_when_block_yields_false
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      5.should.satisfy { false }
    end
  end
  
  def test_should_not_raise_exception_when_block_yields_true
    assert_nothing_raised do
      5.should.satisfy { true }
    end
  end

  # should.not.satisfy
  
  def test_should_raise_exception_when_block_yields_false
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      5.should.not.satisfy { true }
    end
  end
  
  def test_should_not_raise_exception_when_block_yields_true
    assert_nothing_raised do
      5.should.not.satisfy { false }
    end
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

  # should.be

  def test_should_be_same_as_should_not_raise_when_objects_are_same
    assert_nothing_raised do
      @dummy.should.be @dummy
    end
  end

  def test_should_be_same_as_should_raise_when_objects_are_not_same
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should.be @equal_dummy
    end
  end

  def test_should_be_nil_should_not_raise_when_object_is_nil
    assert_nothing_raised do
      @nil_var.should.be nil
    end  
  end

  def test_should_be_nil_should_raise_when_object_is_not_nil
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should.be nil
    end
  end

  # should.not.be

  def test_should_not_be_same_as_should_not_raise_when_objects_are_not_same
    assert_nothing_raised do
      @dummy.should.not.be @equal_dummy
    end
  end

  def test_should_not_be_same_as_should_raise_when_objects_are_not_same
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @dummy.should.not.be @dummy
    end
  end

  def test_should_not_be_nil_should_not_raise_when_object_is_not_nil
    assert_nothing_raised do
      @dummy.should.not.be nil
    end  
  end

  def test_should_not_be_nil_should_raise_when_object_is_nil
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      @nil_var.should.not.be nil
    end
  end

# should.match

  def test_should_match_should_not_raise_when_objects_match
    assert_nothing_raised do
      "hi aslak".should.match /aslak/
    end
  end

  def test_should_equal_should_raise_when_objects_do_not_match
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hi aslak".should.match /steve/
    end
  end

  # should.not.match

  def test_should_not_match_should_not_raise_when_objects_do_not_match
    assert_nothing_raised do
      "hi aslak".should.not.match /steve/
    end
  end

  def test_should_not_match_should_raise_when_objects_match
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hi aslak".should.not.match /aslak/
    end
  end
      
  # should.be.xxx

	def test_should_be_xxx_should_raise_when_target_doesnt_understand_xxx
		assert_raise(NoMethodError) do
      5.should.be.xxx
    end
	end

	def test_should_be_xxx_should_raise_when_sending_xxx_to_target_returns_false
		mock = Mock.new("xxx? returns false")
		mock.should_receive(:xxx?).once.with_no_args.and_return(false)
	  assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      mock.should.be.xxx
    end
		mock.__verify
  end

	def test_should_be_xxx_should_raise_when_sending_xxx_to_target_returns_nil
		mock = Mock.new("xxx? returns nil")
		mock.should_receive(:xxx?).once.with_no_args.and_return(nil)
	  assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      mock.should.be.xxx
    end
		mock.__verify
  end

	def test_should_be_xxx_should_not_raise_when_sending_xxx_to_target_returns_true
		mock = Mock.new("xxx? returns true")
		mock.should_receive(:xxx?).once.with_no_args.and_return(true)
	  assert_nothing_raised do
      mock.should.be.xxx
    end
		mock.__verify
  end

	def test_should_be_xxx_should_not_raise_when_sending_xxx_to_target_returns_something_other_than_true_false_or_nil
		mock = Mock.new("xxx? returns 5")
		mock.should_receive(:xxx?).once.with_no_args.and_return(5)
	  assert_nothing_raised do
      mock.should.be.xxx
    end
		mock.__verify
  end

	# should.be.xxx(args)
	
  def test_should_be_xxx_with_args_passes_args_properly
 		mock = Mock.new("xxx?(1 2 3) returns true")
		mock.should_receive(:xxx?).once.with(1, 2, 3).and_return(true)
	  assert_nothing_raised do
      mock.should.be.xxx(1, 2, 3)
    end
		mock.__verify
  end

  # should.not.be.xxx

	def test_should_not_be_xxx_should_raise_when_target_doesnt_understand_xxx
		assert_raise(NoMethodError) do
      5.should.not.be.xxx
    end
	end

	def test_should_not_be_xxx_should_raise_when_sending_xxx_to_target_returns_true
		mock = Mock.new("xxx? returns true")
		mock.should_receive(:xxx?).once.with_no_args.and_return(true)
	  assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      mock.should.not.be.xxx
    end
		mock.__verify
  end

	def test_should_not_be_xxx_shouldnt_raise_when_sending_xxx_to_target_returns_nil
		mock = Mock.new("xxx? returns nil")
		mock.should_receive(:xxx?).once.with_no_args.and_return(nil)
	  assert_nothing_raised do
      mock.should.not.be.xxx
    end
		mock.__verify
  end

	def test_should_not_be_xxx_shouldnt_raise_when_sending_xxx_to_target_returns_false
		mock = Mock.new("xxx? returns false")
		mock.should_receive(:xxx?).once.with_no_args.and_return(false)
	  assert_nothing_raised do
      mock.should.not.be.xxx
    end
		mock.__verify
  end

	def test_should_not_be_xxx_should_raise_when_sending_xxx_to_target_returns_something_other_than_true_false_or_nil
		mock = Mock.new("xxx? returns 5")
		mock.should_receive(:xxx?).once.with_no_args.and_return(5)
	  assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      mock.should.not.be.xxx
    end
		mock.__verify
  end
  
  
	# should.be.xxx(args)
	
  def test_should_not_be_xxx_with_args_passes_args_properly
 		mock = Mock.new("xxx?(1 2 3) returns false")
		mock.should_receive(:xxx?).once.with(1, 2, 3).and_return(false)
	  assert_nothing_raised do
      mock.should.not.be.xxx(1, 2, 3)
    end
		mock.__verify
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
  
  # violated
  
  def test_violated_should_raise
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      c = Spec::Context.new
      c.violated "boo"
    end
  end
  
  # should.be true
  
  def test_should_be_true_should_raise_when_object_is_nil
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      nil.should.be true
    end
  end
  
  def test_should_be_true_should_raise_when_object_is_false
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      false.should.be true
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_true
    assert_nothing_raised do
      true.should.be true
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_number
    assert_nothing_raised do
      5.should.be true
    end
  end
  
  def test_should_be_true_shouldnt_raise_when_object_is_a_string
    assert_nothing_raised do
      "hello".should.be true
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_some_random_object
    assert_nothing_raised do
      self.should.be true
    end
  end

  # should.be false

  def test_should_be_false_shouldnt_raise_when_object_is_nil
    assert_nothing_raised do
      nil.should.be false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_false
    assert_nothing_raised do
      false.should.be false
    end
  end

  def test_should_be_true_should_raise_when_object_is_true
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      true.should.be false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_number
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      5.should.be false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_string
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      "hello".should.be false
    end
  end

  def test_should_be_true_shouldnt_raise_when_object_is_a_some_random_object
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      self.should.be false
    end
  end

  # should.raise
  
  def test_should_raise_should_pass_when_proper_exception_is_raised
    assert_nothing_raised do
      proc { ''.nonexistant_method }.should.raise NoMethodError
    end
  end
  
  def test_should_raise_should_fail_when_wrong_exception_is_raised
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      proc { ''.nonexistant_method }.should.raise SyntaxError
    end
  end
  
  def test_should_raise_should_fail_when_no_exception_is_raised
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      proc {''.to_s}.should.raise NoMethodError
    end
  end
  
  # should.not.raise
  
  def test_should_not_raise_should_fail_when_specific_exception_is_raised
    assert_raise(Spec::Exceptions::ExpectationNotMetError) do
      proc { ''.nonexistant_method }.should.not.raise NoMethodError
    end
  end
  
  def test_should_not_raise_should_pass_when_other_exception_is_raised
    assert_nothing_raised do
      proc { ''.nonexistant_method }.should.not.raise SyntaxError
    end
  end
  
  def test_should_not_raise_should_pass_when_no_exception_is_raised
    assert_nothing_raised do
      proc { ''.to_s }.should.not.raise NoMethodError
    end
  end

	# should.be.an.instance.of <class>
	
	def test_should_be_an_instance_of_should_pass_when_target_is_specified_class
		assert_nothing_raised do
			5.should.be.an.instance.of Fixnum
		end
	end
	
	def test_should_be_an_instance_of_should_fail_when_target_is_not_specified_class
		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
			5.should.be.an.instance.of Integer
		end
	end
	
	# should.be.a.kind.of <class>
	
	def test_should_be_a_kind_of_should_pass_when_target_is_of_specified_class
		assert_nothing_raised do
			5.should.be.a.kind.of Fixnum
		end
	end

	def test_should_be_a_kind_of_should_pass_when_target_is_of_subclass_of_specified_class
		assert_nothing_raised do
			5.should.be.a.kind.of Integer
		end
	end

	def test_should_be_an_instance_of_should_fail_when_target_is_not_specified_class
		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
			5.should.be.a.kind.of String
		end
	end
	
	# should.not.be.an.instance_of <class>
	
	def test_should_not_be_an_instance_of_should_fail_when_target_is_of_specified_class
		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
			'hello'.should.not.be.an.instance.of String
		end
	end
	
	def test_should_be_an_instance_of_should_pass_when_target_is_not_of_specified_class
		assert_nothing_raised do
			[].should.not.be.an.instance.of String
		end
	end

	# should.be.a.kind.of <class>
	
	def test_should_not_be_a_kind_of_should_fail_when_target_is_of_specified_class
		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
			5.should.not.be.a.kind.of Fixnum
		end
	end

	def test_should_not_be_a_kind_of_should_fail_when_target_is_of_subclass_of_specified_class
		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
			5.should.not.be.a.kind.of Integer
		end
	end

	def test_should_not_be_an_instance_of_should_pass_when_target_is_not_specified_class
		assert_nothing_raised do
			5.should.not.be.a.kind.of String
		end
	end
	
	# should.respond.to <message>
	
	def test_should_respond_to_should_pass_when_target_does
		assert_nothing_raised do
			"".should.respond.to :length
		end
	end

	def test_should_respond_to_should_fail_when_target_doesnt
		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
			"".should.respond.to :connect
		end
	end

	# should.not.respond.to <message>
	
	def test_not_should_respond_to_should_fail_when_target_does
		assert_raise(Spec::Exceptions::ExpectationNotMetError) do
			"".should.not.respond.to :length
		end
	end

	def test_not_should_respond_to_should_pass_when_target_doesnt
		assert_nothing_raised do
			"".should.not.respond.to :connect
		end
	end

end
