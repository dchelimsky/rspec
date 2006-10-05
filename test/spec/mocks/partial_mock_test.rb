require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Mocks
    class PartialMockUsingMocksDirectlyTest < Test::Unit::TestCase
      def setup
        klass = Class.new
        klass.class_eval do
          def existing_method
            :original_value
          end
        end
        @obj = klass.new
      end
      
      def test_should_pass_when_expected_message_is_received
        @obj.should_receive(:msg)
        @obj.msg
        @obj.__verify
      end
      
      def test_should_fail_when_expected_message_is_not_received
        @obj.should_receive(:msg)
        assert_raises Spec::Mocks::MockExpectationError do
          @obj.__verify
        end
      end
      
      def test_should_pass_when_message_is_received_with_correct_args
        @obj.should_receive(:msg).with(:correct_arg)
        @obj.msg :correct_arg
        @obj.__verify
      end

      def test_should_fail_when_message_is_received_with_incorrect_args
        @obj.should_receive(:msg).with(:correct_arg)
        assert_raises Spec::Mocks::MockExpectationError do
          @obj.msg :incorrect_arg
        end
      end

      def test_should_clear_expectations_on_verify
        @obj.should_receive(:msg)
        @obj.msg
        @obj.__verify
        assert_raises NoMethodError do
          @obj.msg
        end
      end
      
      def test_should_revert_to_original_method_if_existed
        @obj.existing_method.should_equal :original_value
        @obj.should_receive(:existing_method).and_return(:mock_value)
        @obj.existing_method.should_equal :mock_value
        @obj.__verify
        @obj.existing_method.should_equal :original_value
      end

    end
    
    class PartialMockTest < Test::Unit::TestCase

      def setup
        @object = Object.new
      end

      def test_should_receive__should_return_a_message_expectation
        assert_kind_of MessageExpectation, @object.should_receive(:foobar)
      end

      def test_should_not_receive__should_return_a_negative_message_expectation
        assert_kind_of NegativeMessageExpectation, @object.should_not_receive(:foobar)
      end

      def test_should_receive__should_mock_out_the_method
        @object.should_receive(:foobar).with(:test_param).and_return(1)
        assert_equal 1, @object.foobar(:test_param)
      end

      def test_should_receive__should_verify_method_was_called
        @object.should_receive(:foobar).with(:test_param).and_return(1)
        assert_raises(Spec::Mocks::MockExpectationError) do
          @object.__verify
        end
      end

      def test_should_not_receive__should_mock_out_the_method
        @object.should_not_receive(:fuhbar)
        @object.fuhbar
        assert_raises (Spec::Mocks::MockExpectationError) do
          @object.__verify
        end
      end
    end
  end
end