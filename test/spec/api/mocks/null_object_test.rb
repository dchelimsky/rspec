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
    end
  end
end