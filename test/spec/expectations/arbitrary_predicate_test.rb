require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper

      class ShouldBeArbitraryPredicateTest < Test::Unit::TestCase

        # should_be_<predicate>

        def test_should_pass_when_predicate_returns_true
          mock = HandCodedMock.new(true)
          assert_nothing_raised do
            mock.should_be_funny
          end
          mock.__verify
        end

        def test_should_fail_when_predicate_returns_false
          mock = HandCodedMock.new(false)
          assert_raise(ExpectationNotMetError) do
            mock.should_be_funny
          end
        end

        def test_should_fail_when_predicate_returns_nil
          mock = HandCodedMock.new(nil)
          assert_raise(ExpectationNotMetError) do
            mock.should_be_funny
          end
          mock.__verify
        end

        def test_should_fail_when_method_returns_something_other_than_true_false_or_nil
          mock = HandCodedMock.new(5)
          assert_nothing_raised do
            mock.should_be_funny
          end
          mock.__verify
        end

        def test_should_raise_when_target_does_not_respond_to_predicate
          assert_raise(NoMethodError) do
            5.should_be_funny
          end
        end

        # should_be_funny(args)
  
        def test_should_pass_when_predicate_accepts_args_and_returns_true
          mock = HandCodedMock.new(true)
          assert_nothing_raised do
            mock.should_be_hungry(1, 2, 3)
          end
          mock.__verify
        end

        def test_should_fail_when_predicate_accepts_args_and_returns_false
          mock = HandCodedMock.new(false)
          assert_raise(ExpectationNotMetError) do
            mock.should_be_hungry(1, 2, 3)
          end
          mock.__verify
        end

        # should_exist => exists?
        
        def test_should_support_plural_form
          mock = HandCodedMock.new(true)
          assert_nothing_raised do
            mock.should_exist
          end
        end

      end
      
      class AnyMethodThatReturnsBooleanTest < Test::Unit::TestCase

        #from patch submitted by Mike Williams - supports any method that returns boolean,
        # regardless of whether it is formed as a ruby predicate

        def test_should_pass_when_expecting_true_and_method_returns_true
          assert_nothing_raised do
            ClassWithUnqueriedPredicate.new(true).should_be_foo
          end
        end

        def test_should_pass_when_expecting_false_and_method_returns_false
          assert_nothing_raised do
            ClassWithUnqueriedPredicate.new(false).should_not_be_foo
          end
        end

        def test_should_fail_when_expecting_true_and_method_returns_false
          assert_raise(ExpectationNotMetError) do
            ClassWithUnqueriedPredicate.new(false).should_be_foo
          end
        end

        def test_should_fail_when_expecting_false_and_method_returns_true
          assert_raise(ExpectationNotMetError) do
            ClassWithUnqueriedPredicate.new(true).should_not_be_foo
          end
        end

      end
      
      class ShouldNotBeArbitraryPredicateTest < Test::Unit::TestCase

        # should_not_be_funny

        def test_should_pass_when_predicate_returns_false
          mock = HandCodedMock.new(false)
          assert_nothing_raised do
            mock.should_not_be_funny
          end
          mock.__verify
        end

        def test_should_fail_when_predicate_returns_true
          mock = HandCodedMock.new(true)
          assert_raise(ExpectationNotMetError) do
            mock.should_not_be_funny
          end
          mock.__verify
        end

        def test_should_pass_when_predicate_returns_nil
          mock = HandCodedMock.new(nil)
          assert_nothing_raised do
            mock.should_not_be_funny
          end
          mock.__verify
        end

        def test_should_fail_when_method_returns_something_other_than_true_false_or_nil
          mock = HandCodedMock.new(5)
          assert_raise(ExpectationNotMetError) do
            mock.should_not_be_funny
          end
          mock.__verify
        end

        def test_should_raise_when_target_does_not_respond_to_predicate
          assert_raise(NoMethodError) do
            5.should_not_be_funny
          end
        end
          
        # should_be_funny(args)
  
        def test_should_fail_when_predicate_accepts_args_and_returns_true
          mock = HandCodedMock.new(true)
          assert_raise(ExpectationNotMetError) do
            mock.should_not_be_hungry(1, 2, 3)
          end
          mock.__verify
        end

        def test_should_pass_when_predicate_accepts_args_and_returns_false
          mock = HandCodedMock.new(false)
          assert_nothing_raised do
            mock.should_not_be_hungry(1, 2, 3)
          end
          mock.__verify
        end

      end
    end
  end
end
