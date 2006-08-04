require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    class OnceCountsTest < Test::Unit::TestCase
      
      def setup
        @mock = Mock.new("test mock")
      end
      
      def test_once_should_pass_when_called_once
        @mock.should_receive(:random_call).once
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_once_should_pass_when_called_once_with_unspecified_args
        @mock.should_receive(:random_call).once
        @mock.random_call("a","b","c")
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_once_should_pass_when_called_once_with_specified_args
        @mock.should_receive(:random_call).once_with("a","b","c")
        @mock.random_call("a","b","c")
        assert_nothing_raised do
          @mock.__verify
        end
      end
      
      def test_once_should_fail_when_not_called
        @mock.should_receive(:random_call).once
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def test_once_should_fail_when_called_twice
        @mock.should_receive(:random_call).once
        @mock.random_call
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def FIXME_test_once_should_fail_when_called_once_with_wrong_args
        @mock.should_receive(:random_call).once_with("a","b","c")
        @mock.random_call "d","e","f"
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
    end
    
    class TwiceCountsTest < Test::Unit::TestCase

      def setup
        @mock = Mock.new("test mock")
      end
      
      def test_twice_should_pass_when_called_twice
        @mock.should_receive(:random_call).twice
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_twice_should_pass_when_called_twice_with_unspecified_args
        @mock.should_receive(:random_call).twice
        @mock.random_call "1"
        @mock.random_call 1
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_twice_should_pass_when_called_twice_with_specified_args
        @mock.should_receive(:random_call).twice_with("1", 1)
        @mock.random_call "1", 1
        @mock.random_call "1", 1
        assert_nothing_raised do
          @mock.__verify
        end
      end

      #TODO - this fails because the mock raises on the call with the wrong args, rather than waiting for verification
      def FIXMEtest_twice_should_fail_when_called_twice_with_wrong_args_on_the_second_call
        @mock.should_receive(:random_call).twice_with("1", 1)
        @mock.random_call "1", 1
        @mock.random_call 1, "1"
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def FIXMEtest_twice_should_fail_when_called_twice_with_wrong_args_on_the_first_call
        @mock.should_receive(:random_call).twice_with("1", 1)
        @mock.random_call 1, "1"
        @mock.random_call "1", 1
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def test_twice_should_fail_when_call_count_is_lower_than_expected
        @mock.should_receive(:random_call).twice
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def test_twice_should_fail_when_call_count_is_higher_than_expected
        @mock.should_receive(:random_call).twice
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
    end

    class PreciseCountsTest < Test::Unit::TestCase
      
      def setup
        @mock = Mock.new("test mock")
      end

      def test_should_pass_if_any_number_of_times_method_is_not_called
        @mock.should_receive(:random_call).any_number_of_times
        assert_nothing_raised do
          @mock.__verify
        end
      end
  
      def test_should_pass_if_any_number_of_times_method_is_called_once
        @mock.should_receive(:random_call).any_number_of_times
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end
  
      def test_should_pass_if_any_number_of_times_method_is_called_many_times
        @mock.should_receive(:random_call).any_number_of_times
        (1..10).each { @mock.random_call }
        assert_nothing_raised do
          @mock.__verify
        end
      end
  
      def test_should_pass_mutiple_calls_with_different_args
        @mock.should_receive(:random_call).once_with(1)
        @mock.should_receive(:random_call).once_with(2)
        @mock.random_call(1)
        @mock.random_call(2)
        assert_nothing_raised do
          @mock.__verify
        end
      end
  
      def test_should_pass_multiple_calls_with_different_args_and_counts
        @mock.should_receive(:random_call).twice_with(1)
        @mock.should_receive(:random_call).once_with(2)
        @mock.random_call(1)
        @mock.random_call(2)
        @mock.random_call(1)
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_should_fail_if_exactly_n_times_method_is_never_called
        @mock.should_receive(:random_call).exactly(3).times
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_fail_if_exactly_n_times_method_is_called_less_than_n_times
        @mock.should_receive(:random_call).exactly(3).times
        @mock.random_call
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_pass_if_exactly_n_times_method_is_called_exactly_n_times
        @mock.should_receive(:random_call).exactly(3).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end
      
    end
    
    class MockRelativeCountsTest < Test::Unit::TestCase
      
      def setup
        @mock = Mock.new("test mock")
      end

      def test_should_fail_if_at_least_once_method_is_never_called
        @mock.should_receive(:random_call).at_least(:once)
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
  
      def test_should_pass_if_at_least_once_method_is_called_once
        @mock.should_receive(:random_call).at_least(:once)
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end
  
      def test_should_pass_if_at_least_once_method_is_called_twice
        @mock.should_receive(:random_call).at_least(:once)
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_should_fail_if_at_least_twice_method_is_never_called
        @mock.should_receive(:random_call).at_least(:twice)
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def test_should_fail_if_at_least_twice_method_is_called_once
        @mock.should_receive(:random_call).at_least(:twice)
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_pass_if_at_least_twice_method_is_called_twice
        @mock.should_receive(:random_call).at_least(:twice)
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_should_pass_if_at_least_twice_method_is_called_three_times
        @mock.should_receive(:random_call).at_least(:twice)
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end
      
      def test_should_fail_at_least_n_times_method_is_never_called
        @mock.should_receive(:random_call).at_least(4).times
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_fail_if_at_least_n_times_method_is_called_less_than_n_times
        @mock.should_receive(:random_call).at_least(4).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_pass_if_at_least_n_times_method_is_called_exactly_n_times
        @mock.should_receive(:random_call).at_least(4).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end
      
      def test_should_pass_if_at_least_n_times_method_is_called_n_plus_1_times
        @mock.should_receive(:random_call).at_least(4).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_should_use_last_return_value_for_subsequent_calls
        @mock.should_receive(:multi_call).at_least(:once).with(:no_args).and_return([11, 22])
        assert_equal(11, @mock.multi_call)
        assert_equal(22, @mock.multi_call)
        assert_equal(22, @mock.multi_call)
        assert_nothing_raised do
          @mock.__verify
        end
      end
  
    end
  end
end