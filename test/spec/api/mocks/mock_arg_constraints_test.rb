require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    class PassingConstraintsTest < Test::Unit::TestCase
      
      def setup
        @mock = Mock.new("test mock")
      end

      def test_should_handle_any_arg
        @mock.should.receive(:random_call).with("a", :anything, "c")
        @mock.random_call("a", "whatever", "c")
        @mock.__verify
      end
      
      def test_should_accept_fixnum_as_numeric
        @mock.should.receive(:random_call).with(:numeric)
        @mock.random_call(1)
        @mock.__verify
      end
      
      def test_should_accept_float_as_numeric
        @mock.should.receive(:random_call).with(:numeric)
        @mock.random_call(1.5)
        @mock.__verify
      end
      
      def test_should_match_true_for_boolean
        @mock.should.receive(:random_call).with(:boolean)
        @mock.random_call(true)
        @mock.__verify
      end
      
      def test_should_match_false_for_boolean
        @mock.should.receive(:random_call).with(:boolean)
        @mock.random_call(false)
        @mock.__verify
      end
      
      def test_should_match_string
        @mock.should.receive(:random_call).with(:string)
        @mock.random_call("a string")
        @mock.__verify
      end
      
      def test_should_match_non_special_symbol
        @mock.should.receive(:random_call).with(:some_symbol)
        @mock.random_call(:some_symbol)
        @mock.__verify
      end
      
      def test_should_process_duck_type_with_one_method
        @mock.should.receive(:random_call).with(DuckTypeArgConstraint.new(:length))
        @mock.random_call([])
        @mock.__verify
      end
      
      def test_should_process_duck_type_with_two_methods
        @mock.should.receive(:random_call).with(DuckTypeArgConstraint.new(:abs, :div))
        @mock.random_call(1)
        @mock.__verify
      end
      
    end
    
    class FailingConstraintsTest < Test::Unit::TestCase
      
      def setup
        @mock = Mock.new("test mock")
      end

      def test_should_reject_non_numeric
        @mock.should.receive(:random_call).with(:numeric)
        assert_raise(MockExpectationError) do
          @mock.random_call("1")
          @mock.__verify
        end
      end
      
      def test_should_reject_non_boolean
        @mock.should.receive(:random_call).with(:boolean)
        assert_raise(MockExpectationError) do
          @mock.random_call("false")
          @mock.__verify
        end
      end
      
      def test_should_reject_non_string
        @mock.should.receive(:random_call).with(:string)
        assert_raise(MockExpectationError) do
          @mock.random_call(123)
          @mock.__verify
        end
      end
      
      def test_should_reject_goose_when_expecting_a_duck
        @mock.should.receive(:random_call).with(DuckTypeArgConstraint.new(:abs, :div))
        assert_raise(MockExpectationError) do
          @mock.random_call("I don't respond to :abs or :div")
          @mock.__verify
        end
      end
      
    end
  end
end