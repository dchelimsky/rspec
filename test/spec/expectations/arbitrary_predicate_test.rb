require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper

      class ArbitraryPredicateTest < Test::Unit::TestCase

        # should_be_funny

        def test_should_be_funny_should_raise_when_target_doesnt_understand_funny
          assert_raise(ExpectationNotMetError) do
            5.should_be_funny
          end
        end

        def test_should_be_funny_should_raise_when_sending_funny_to_target_returns_false
          mock = HandCodedMock.new(false)
          assert_raise(ExpectationNotMetError) do
            mock.should_be_funny
          end
          mock.__verify
        end

        def test_should_be_funny_should_raise_when_sending_funny_to_target_returns_nil
          mock = HandCodedMock.new(nil)
          assert_raise(ExpectationNotMetError) do
            mock.should_be_funny
          end
          mock.__verify
        end

        def test_should_be_funny_should_not_raise_when_sending_funny_to_target_returns_true
          mock = HandCodedMock.new(true)
          assert_nothing_raised do
            mock.should_be_funny
          end
          mock.__verify
        end

        def test_should_be_funny_should_not_raise_when_sending_funny_to_target_returns_something_other_than_true_false_or_nil
          mock = HandCodedMock.new(5)
          assert_nothing_raised do
            mock.should_be_funny
          end
          mock.__verify
        end

        # should_be_funny(args)
  
        def test_should_be_funny_with_args_passes_args_properly
          mock = HandCodedMock.new(true)
          assert_nothing_raised do
            mock.should_be_hungry(1, 2, 3)
          end
          mock.__verify
        end

        # should_not_be_funny

        def test_should_not_be_funny_should_raise_when_target_doesnt_understand_funny
          assert_raise(NoMethodError) do
            5.should_not_be_funny
          end
        end

        def test_should_not_be_funny_should_raise_when_sending_funny_to_target_returns_true
          mock = HandCodedMock.new(true)
          assert_raise(ExpectationNotMetError) do
            mock.should_not_be_funny
          end
          mock.__verify
        end

        def test_should_not_be_funny_shouldnt_raise_when_sending_funny_to_target_returns_nil
          mock = HandCodedMock.new(nil)
          assert_nothing_raised do
            mock.should_not_be_funny
          end
          mock.__verify
        end

        def test_should_not_be_funny_shouldnt_raise_when_sending_funny_to_target_returns_false
          mock = HandCodedMock.new(false)
          assert_nothing_raised do
            mock.should_not_be_funny
          end
          mock.__verify
        end

        def test_should_not_be_funny_should_raise_when_sending_funny_to_target_returns_something_other_than_true_false_or_nil
          mock = HandCodedMock.new(5)
          assert_raise(ExpectationNotMetError) do
            mock.should_not_be_funny
          end
          mock.__verify
        end
  
        # should_be_funny(args)
  
        def test_should_not_be_funny_with_args_passes_args_properly
          mock = HandCodedMock.new(false)
          assert_nothing_raised do
            mock.should_not_be_hungry(1, 2, 3)
          end
          mock.__verify
        end

        # should_exist => exists?
        
        def test_should_try_plural_form
          mock = HandCodedMock.new(true)
          assert_nothing_raised do
            mock.should_exist
          end
        end
      end
    end
  end
end
