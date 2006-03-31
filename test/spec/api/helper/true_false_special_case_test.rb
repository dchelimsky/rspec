require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class TrueFalseSpecialCaseTest < Test::Unit::TestCase

        # should.be true
  
        def test_should_be_true_should_raise_when_object_is_nil
          assert_raise(Spec::Api::ExpectationNotMetError) do
            nil.should.be true
          end
        end
  
        def test_should_be_true_should_raise_when_object_is_false
          assert_raise(Spec::Api::ExpectationNotMetError) do
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

        def test_should_be_false_shouldnt_raise_when_object_is_false
          assert_nothing_raised do
            false.should.be false
          end
        end

        def test_should_be_false_should_raise_when_object_is_true
          assert_raise(Spec::Api::ExpectationNotMetError) do
            true.should.be false
          end
        end

        def test_should_be_false_shouldnt_raise_when_object_is_a_number
          assert_raise(Spec::Api::ExpectationNotMetError) do
            5.should.be false
          end
        end

        def test_should_be_false_shouldnt_raise_when_object_is_a_string
          assert_raise(Spec::Api::ExpectationNotMetError) do
            "hello".should.be false
          end
        end

        def test_should_be_false_shouldnt_raise_when_object_is_a_some_random_object
          assert_raise(Spec::Api::ExpectationNotMetError) do
            self.should.be false
          end
        end

      end
    end
  end
end
