require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ShouldBeAnInstanceOfTest < Test::Unit::TestCase

        def test_should_pass_when_target_is_specified_class
          assert_nothing_raised do
            5.should_be_an_instance_of Fixnum
          end
        end
  
        def test_should_fail_when_target_is_not_specified_class
          assert_raise(ExpectationNotMetError) do
            5.should_be_an_instance_of Integer
          end
        end
      end

      class ShouldBeAKindOfTest < Test::Unit::TestCase
  
        def test_should_pass_when_target_is_of_specified_class
          assert_nothing_raised do
            5.should_be_a_kind_of Fixnum
          end
        end

        def test_should_pass_when_target_is_of_subclass_of_specified_class
          assert_nothing_raised do
            5.should_be_a_kind_of Integer
          end
        end

        def test_should_fail_when_target_is_not_specified_class
          assert_raise(ExpectationNotMetError) do
            5.should_be_a_kind_of String
          end
        end
      end

      class ShouldNotBeAnInstanceOfTest < Test::Unit::TestCase
  
        def test_should_fail_when_target_is_of_specified_class
          assert_raise(ExpectationNotMetError) do
            'hello'.should_not_be_an_instance_of String
          end
        end
  
        def test_should_pass_when_target_is_not_of_specified_class
          assert_nothing_raised do
            [].should_not_be_an_instance_of String
          end
        end
      end

      class ShouldNotBeAKindOfTest < Test::Unit::TestCase
  
        def test_should_fail_when_target_is_of_specified_class
          assert_raise(ExpectationNotMetError) do
            5.should_not_be_a_kind_of Fixnum
          end
        end

        def test_should_fail_when_target_is_of_subclass_of_specified_class
          assert_raise(ExpectationNotMetError) do
            5.should_not_be_a_kind_of Integer
          end
        end

        def test_should_pass_when_target_is_not_specified_class
          assert_nothing_raised do
            5.should_not_be_a_kind_of String
          end
        end
      end
  
      class ShouldRespondToTest < Test::Unit::TestCase
        def test_should_pass_when_target_responds_to
          assert_nothing_raised do
            "".should_respond_to :length
          end
        end

        def test_should_fail_when_target_doesnt_respond_to
          assert_raise(ExpectationNotMetError) do
            "".should_respond_to :connect
          end
        end
      end

      class ShouldNotRespondToTest < Test::Unit::TestCase
        def test_should_fail_when_target_responds_to
          assert_raise(ExpectationNotMetError) do
            "".should_not_respond_to :length
          end
        end

        def test_should_pass_when_target_doesnt_respond_to
          assert_nothing_raised do
            "".should_not_respond_to :connect
          end
        end

      end
    end
  end
end
