require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Mocks
    class PartialMockTest < Test::Unit::TestCase

      def setup
        @module = Module.new
      end

      def teardown
        @module.reset_proxied_methods!
      end

      def test_should_receive__should_return_a_message_expectation
        assert_kind_of MessageExpectation, @module.should_receive(:foobar)
        @module.foobar
      end

      def test_should_not_receive__should_return_a_negative_message_expectation
        assert_kind_of NegativeMessageExpectation, @module.should_not_receive(:foobar)
      end

      def test_should_receive__should_mock_out_the_method
        @module.should_receive(:foobar).with(:test_param).and_return(1)
        assert_equal 1, @module.foobar(:test_param)
      end

      def test_should_receive__should_verify_method_was_called
        @module.should_receive(:foobar).with(:test_param).and_return(1)
        assert_raises(Spec::Mocks::MockExpectationError) do
          @module.reset_proxied_methods!
        end
      end

      def test_should_not_receive__should_mock_out_the_method
        @module.should_not_receive(:foobar)

        @module.foobar
        assert_raises(Spec::Mocks::MockExpectationError) do
          @module.reset_proxied_methods!
        end
      end
    end
  end
end