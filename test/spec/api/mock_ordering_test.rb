require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Api

    class MockTest < Test::Unit::TestCase

      def setup
        @mock = Mock.new("test mock")
      end

      def test_two_in_order_calls
        @mock.should.receive(:one).id(:one)
        @mock.should.receive(:two).after(:one)
        @mock.one
        @mock.two
        @mock.__verify
      end

      def test_two_out_of_order_calls
        @mock.should.receive(:one).id(:one)
        @mock.should.receive(:two).after(:one)
        assert_raise(MockExpectationError) do
          @mock.two
        end
      end
      
      def test_three_linear_calls
        @mock.should.receive(:one).id(:one)
        @mock.should.receive(:two).id(:two).after(:one)
        @mock.should.receive(:three).after(:two)
        @mock.one
        @mock.two
        @mock.three
        @mock.__verify
      end

      def test_three_forked_calls
        @mock.should.receive(:one).id(:one)
        @mock.should.receive(:two).after(:one)
        @mock.should.receive(:three).after(:one)
        @mock.one
        @mock.two
        @mock.three
        @mock.__verify
      end

      def test_three_out_of_order_calls
        @mock.should.receive(:one).id(:one)
        @mock.should.receive(:two).id(:two).after(:one)
        @mock.one
        assert_raise(MockExpectationError) do
          @mock.three
        end
      end
      
      def test_two_in_order_calls_set_in_opposite_order
        @mock.should.receive(:two).after(:one)
        @mock.should.receive(:one).id(:one)
        @mock.one
        @mock.two
        @mock.__verify
      end
      
    end
  end
end