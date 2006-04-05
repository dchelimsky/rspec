require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Api

    class MockTest < Test::Unit::TestCase

      def setup
        @mock = Mock.new("test mock")
      end

      def test_should_report_line_number_of_expectation_of_unreceived_message
        @mock.should.receive(:wont_happen).with("x", 3)

        begin
          @mock.__verify
        rescue MockExpectationError => e
          e.backtrace[0].should.match /mock_test\.rb:13:in .test_should_report_line/
        end
    
      end

      def test_should_allow_block_to_calculate_return_values
        @mock.should.receive(:random_call).with("a","b","c").and.return { |a,b,c| c+b+a }
        assert_equal "cba", @mock.random_call("a","b","c")
        # TODO: remove __verify when migrating to self-hosting. Verify happens transparently in teardown. (AH)
        @mock.__verify
      end

      def test_should_allow_parameter_as_return_value
        @mock.should.receive(:random_call).with("a","b","c").and.return("booh")
        assert_equal "booh", @mock.random_call("a","b","c")
        @mock.__verify
      end

      def test_return_nil_if_no_return_value_set
        @mock.should.receive(:random_call).with("a","b","c")
        assert_nil @mock.random_call("a","b","c")
        @mock.__verify
      end

      def test_should_test_multiple_calls_to_method_with_same_parameters
        @mock.should.receive(:random_call).twice.with("a","b","c")
        @mock.random_call("a","b","c")
        @mock.random_call("a","b","c")
        @mock.__verify
      end

      def test_should_raise_exception_if_parameters_dont_match_when_method_called
        @mock.should.receive(:random_call).with("a","b","c").and.return("booh")
        assert_raise(MockExpectationError) {
          @mock.random_call("a","d","c")
        }
      end
     
      def test_should_fail_if_unexpected_method_called
        assert_raise(MockExpectationError) {
          @mock.random_call("a","d","c")
        }
      end
  
      def test_should_allow_unexpected_methods_if_ignore_missing_set
        m = Mock.new("null_object", :null_object=>true)
        m.random_call("a","d","c")
        m.__verify
      end 
  
      # TODO: rename to should_raise_exception_telling_what_message_was_not_received
      def test_should_raise_exception_on_verify_if_call_counts_not_as_expected
        @mock.should.receive(:random_call).twice.with("a","b","c").and.return("booh")
        @mock.random_call("a","b","c")
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def test_should_use_block_for_expectation_if_provided
        @mock.should.receive(:random_call) do | a, b |
          a.should.equal("a")
          b.should.equal("b")
          "booh"
        end
        assert_equal("booh", @mock.random_call("a", "b"))
        @mock.__verify
      end
  
      def test_failing_expectation_block_throws
        @mock.should.receive(:random_call) {| a | a.should.be true}
        assert_raise(MockExpectationError) do
          @mock.random_call false
        end
      end
  
      def test_two_return_values
        @mock.should.receive(:multi_call).twice.with(:nothing).and.return([1, 2])
        assert_equal(1, @mock.multi_call)
        assert_equal(2, @mock.multi_call)
        @mock.__verify
      end
  
      def test_repeating_final_return_value
        @mock.should.receive(:multi_call).at.least(:once).with(:nothing).and.return([1, 2])
        assert_equal(1, @mock.multi_call)
        assert_equal(2, @mock.multi_call)
        assert_equal(2, @mock.multi_call)
        @mock.__verify
      end
  
      def test_should_throw_on_call_of_never_method
        @mock.should.receive(:random_call).never
        assert_raise(MockExpectationError) do
          @mock.random_call
          @mock.__verify
        end
      end
  
      def test_should_throw_if_at_least_once_method_not_called
        @mock.should.receive(:random_call).at.least(:once)
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
  
      def test_should_not_throw_if_any_number_of_times_method_not_called
        @mock.should.receive(:random_call).any.number.of.times
        @mock.__verify
      end
  
      def test_should_not_throw_if_any_number_of_times_method_is_called
        @mock.should.receive(:random_call).any.number.of.times
        @mock.random_call
        @mock.__verify
      end
  
      def test_should_not_throw_if_at_least_once_method_is_called_twice
        @mock.should.receive(:random_call).at.least(:once)
        @mock.random_call
        @mock.random_call
        @mock.__verify
      end
  
      def test_should_support_mutiple_calls_with_different_args
        @mock.should.receive(:random_call).once.with(1)
        @mock.should.receive(:random_call).once.with(2)
        @mock.random_call(1)
        @mock.random_call(2)
        @mock.__verify
      end
  
      def test_should_support_multiple_calls_with_different_args_and_counts
        @mock.should.receive(:random_call).twice.with(1)
        @mock.should.receive(:random_call).once.with(2)
        @mock.random_call(1)
        @mock.random_call(2)
        @mock.random_call(1)
        @mock.__verify
      end

      def test_should_not_throw_if_at_least_twice_method_is_called_twice
        @mock.should.receive(:random_call).at.least(:twice)
        @mock.random_call
        @mock.random_call
        @mock.__verify
      end

      def test_should_not_throw_if_at_least_twice_method_is_called_three_times
        @mock.should.receive(:random_call).at.least(:twice)
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.__verify
      end

      def test_should_throw_if_at_least_twice_method_is_called_once
        @mock.should.receive(:random_call).at.least(:twice)
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_throw_if_at_least_twice_method_is_never_called
        @mock.should.receive(:random_call).at.least(:twice)
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_throw_if_at_least_5_times_method_is_never_called
        @mock.should.receive(:random_call).at.least(5).times
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_throw_if_at_least_5_times_method_is_called_once
        @mock.should.receive(:random_call).at.least(5).times
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_not_throw_if_at_least_5_times_method_is_called_5_times
        @mock.should.receive(:random_call).at.least(5).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.__verify
      end
      
      def test_should_not_throw_if_at_least_5_times_method_is_called_6_times
        @mock.should.receive(:random_call).at.least(5).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.__verify
      end
      
      def test_should_handle_anything_in_multi_args
        @mock.should.receive(:random_call).with("a", :anything, "c")
        @mock.random_call("a", "whatever", "c")
        @mock.__verify
      end

#      def test_raising
#        @mock.should.receive(:random_call).and.raise(RuntimeError)
#        assert_raise(RuntimeError) do
#          @mock.random_call
#        end
#      end
      
    end
  end
end