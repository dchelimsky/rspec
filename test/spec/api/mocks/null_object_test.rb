require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api

    class NullObjectMockTest < Test::Unit::TestCase

      def setup
        @mock = Mock.new("null_object", :null_object=>true)
      end
       
      def test_should_ignore_unexpected_methods
        @mock.random_call("a","d","c")
        @mock.__verify
      end 
    
      def test_should_allow_explicit_expectation
        @mock.should_receive(:something)
        @mock.something
        @mock.__verify
      end
      
      def test_should_fail_verification_when_explicit_exception_not_met
        assert_raises(MockExpectationError) do
          @mock.should_receive(:something)
          @mock.__verify
        end
      end

      def test_should_pass_when_receiving_message_specified_as_not_to_be_received_with_different_args
        @mock.should_not_receive(:message).with("unwanted text")
        @mock.message "other text"
        @mock.__verify
      end
    end
  end
end