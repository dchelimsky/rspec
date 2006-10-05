require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Mocks
    class StubTest < Test::Unit::TestCase
      def setup
        klass = Class.new
        klass.class_eval do
          def existing_method
            :original_value
          end
        end
        @obj = klass.new
      end
      
      def test_should_ignore_when_expected_message_is_received
        @obj.stub!(:msg)
        @obj.msg
        @obj.__verify
      end
      
      def test_should_ignore_when_expected_message_is_not_received
        @obj.stub!(:msg)
        assert_nothing_raised do
          @obj.__verify
        end
      end
      
      def test_should_ignore_when_message_is_received_with_args
        @obj.stub!(:msg)
        @obj.msg :an_arg
        @obj.__verify
      end
    
      def test_should_return_expected_value_when_expected_message_is_received
        @obj.stub!(:msg).and_return :return_value
        @obj.msg.should_equal :return_value
        @obj.__verify
      end
      
      def test_should_revert_to_original_method_if_existed
        @obj.existing_method.should_equal :original_value
        @obj.stub!(:existing_method).and_return(:mock_value)
        @obj.existing_method.should_equal :mock_value
        @obj.__verify
        @obj.existing_method.should_equal :original_value
      end
    end
  end
end