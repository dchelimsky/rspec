require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ShouldBeTrueTest < Test::Unit::TestCase

        def test_should_raise_when_object_is_nil
          assert_raise(ExpectationNotMetError) do
            nil.should_be true
          end
        end
  
        def test_should_raise_when_object_is_false
          assert_raise(ExpectationNotMetError) do
            false.should_be true
          end
        end

        def test_shouldnt_raise_when_object_is_true
          assert_nothing_raised do
            true.should_be true
          end
        end

        def test_shouldnt_raise_when_object_is_a_number
          assert_nothing_raised do
            5.should_be true
          end
        end
  
        def test_shouldnt_raise_when_object_is_a_string
          assert_nothing_raised do
            "hello".should_be true
          end
        end

        def test_shouldnt_raise_when_object_is_a_some_random_object
          assert_nothing_raised do
            self.should_be true
          end
        end
      end

      class ShouldBeFalseTest < Test::Unit::TestCase
        def test_shouldnt_raise_when_object_is_nil
          assert_nothing_raised do
            nil.should_be false
          end
        end

        def test_shouldnt_raise_when_object_is_false
          assert_nothing_raised do
            false.should_be false
          end
        end

        def test_should_raise_when_object_is_true
          assert_raise(ExpectationNotMetError) do
            true.should_be false
          end
        end

        def test_shouldnt_raise_when_object_is_a_number
          assert_raise(ExpectationNotMetError) do
            5.should_be false
          end
        end

        def test_shouldnt_raise_when_object_is_a_string
          assert_raise(ExpectationNotMetError) do
            "hello".should_be false
          end
        end

        def test_shouldnt_raise_when_object_is_a_some_random_object
          assert_raise(ExpectationNotMetError) do
            self.should_be false
          end
        end

      end
    end
  end
end
