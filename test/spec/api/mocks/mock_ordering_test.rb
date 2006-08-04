require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api

    class MockTest < Test::Unit::TestCase

      def setup
        @mock = Mock.new("test mock")
      end

      def test_should_pass_two_calls_in_order
        @mock.should_receive(:one).ordered
        @mock.should_receive(:two).ordered
        @mock.one
        @mock.two
        @mock.__verify
      end

      def test_should_pass_three_calls_in_order
        @mock.should_receive(:one).ordered
        @mock.should_receive(:two).ordered
        @mock.should_receive(:three).ordered
        @mock.one
        @mock.two
        @mock.three
        @mock.__verify
      end

      def test_should_fail_if_second_call_comes_first
        @mock.should_receive(:one).ordered
        @mock.should_receive(:two).ordered
        assert_raise(MockExpectationError) do
          @mock.two
        end
      end

      def test_should_fail_if_third_call_comes_first
        @mock.should_receive(:one).ordered
        @mock.should_receive(:two).ordered
        @mock.should_receive(:three).ordered
        @mock.one
        assert_raise(MockExpectationError) do
          @mock.three
        end
      end
      
      def test_should_fail_if_third_call_comes_second
        @mock.should_receive(:one).ordered
        @mock.should_receive(:two).ordered
        @mock.should_receive(:three).ordered
        @mock.one
        assert_raise(MockExpectationError) do
          @mock.one
          @mock.three
        end
      end

      def test_should_ignore_order_of_non_ordered_calls
        @mock.should_receive(:ignored_0)
        @mock.should_receive(:ordered_1).ordered
        @mock.should_receive(:ignored_1)
        @mock.should_receive(:ordered_2).ordered
        @mock.should_receive(:ignored_2)
        @mock.should_receive(:ignored_3)
        @mock.should_receive(:ordered_3).ordered
        @mock.should_receive(:ignored_4)
        @mock.ignored_3
        @mock.ordered_1
        @mock.ignored_0
        @mock.ordered_2
        @mock.ignored_4
        @mock.ignored_2
        @mock.ordered_3
        @mock.ignored_1
        @mock.__verify
      end
      
      def FIXME_test_two_in_order_calls_with_block
        @mock.should_receive(:doit).ordered do |a, b|
          a.should_equal "a1"
          a.should_equal "b1"
        end
        @mock.should_receive(:doit).ordered do |a, b|
          a.should_equal "a2"
          a.should_equal "b2"
        end
        @mock.doit "a1", "b1"
        @mock.doit "b1", "b2"
        @mock.__verify
      end

      def FIXME_test_two_out_of_order_calls_with_block
        @mock.should_receive(:doit).ordered do |a, b|
          a.should_equal "a1"
          a.should_equal "b1"
        end
        @mock.should_receive(:doit).ordered do |a, b|
          a.should_equal "a2"
          a.should_equal "b2"
        end
        @mock.doit "b1", "b2"
        @mock.doit "a1", "b1"
        @mock.__verify
      end
      
    end
  end
end