require File.dirname(__FILE__) + '/../../../test_helper'

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
        @mock.should.receive(:multi_call).twice.with(:no_args).and.return([8, 12])
        assert_equal(8, @mock.multi_call)
        assert_equal(12, @mock.multi_call)
        @mock.__verify
      end
  
      def test_repeating_final_return_value
        @mock.should.receive(:multi_call).at.least(:once).with(:no_args).and.return([11, 22])
        assert_equal(11, @mock.multi_call)
        assert_equal(22, @mock.multi_call)
        assert_equal(22, @mock.multi_call)
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
      
      def test_should_raise_if_exactly_3_times_method_is_not_called
        @mock.should.receive(:random_call).exactly(3).times
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_raise_if_exactly_3_times_method_is_called_once
        @mock.should.receive(:random_call).exactly(3).times
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_raise_if_exactly_3_times_method_is_called_twice
        @mock.should.receive(:random_call).exactly(3).times
        @mock.random_call
        @mock.random_call
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end
      
      def test_should_not_raise_if_exactly_3_times_method_is_called_3_times
        @mock.should.receive(:random_call).exactly(3).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.__verify
        end
      end

      def test_should_raise_if_exactly_3_times_method_is_called_4_times
        @mock.should.receive(:random_call).exactly(3).times
        @mock.random_call
        @mock.random_call
        @mock.random_call
        assert_nothing_raised do
          @mock.random_call
        end
      end

      def test_should_raise_when_told_to
        @mock.should.receive(:random_call).and.raise(RuntimeError)
        assert_raise(RuntimeError) do
          @mock.random_call
        end
      end
 
      def test_should_not_raise_when_told_to_if_args_dont_match
        @mock.should.receive(:random_call).with(2).and.raise(RuntimeError)
        assert_raise(MockExpectationError) do
          @mock.random_call(1)
        end
      end
 
      def test_should_throw_when_told_to
        @mock.should.receive(:random_call).and.throw(:blech)
        assert_throws(:blech) do
          @mock.random_call
        end
      end

      def test_should_raise_when_explicit_return_and_block_constrained
        assert_raise(AmbiguousReturnError) {
          @mock.should.receive(:fruit){|colour|
            :strawberry
          }.and.return :apple
        }
      end
      
      def TODO_test_should_use_past_tense
        @mock.should.have.received(:hello)
      end

      def TODO_test_should_sent
        cut.should.have.sent(:hello)
        cut.should.have.sent(:hello).to(@mock)
      end
     
      def test_should_ignore_args_on_any_args
        @mock.should.receive(:random_call).at.least(:once).with(:any_args)
        @mock.random_call()
        @mock.random_call(1)
        @mock.random_call("a", 2)
        @mock.random_call([], {}, "joe", 7)
        @mock.__verify
      end
      
      def test_should_throw_on_no_args_if_any_args_received
        @mock.should.receive(:random_call).with(:no_args)
        assert_raise(MockExpectationError) do
          @mock.random_call(1)
        end
      end
      
      def test_should_yield_values
        @mock.should.receive(:yield_back).with(:no_args).once.and.yield('wha', 'zup')
        a, b = nil
        @mock.yield_back {|a,b|}
        a.should.equal 'wha'
        b.should.equal 'zup'
        @mock.__verify
      end

      def test_should_yield_single_values
        @mock.should.receive(:yield_back).with(:no_args).once.and.yield(99)
        a = nil
        @mock.yield_back {|a|}
        a.should.equal 99
        @mock.__verify
      end

      def test_should_fail_when_calling_yielding_method_with_wrong_arity
        @mock.should.receive(:yield_back).with(:no_args).once.and.yield('wha', 'zup')
        assert_raise(MockExpectationError) do
          @mock.yield_back {|a|}
        end
      end

      def test_should_fail_when_calling_yielding_method_without_block
        @mock.should.receive(:yield_back).with(:no_args).once.and.yield('wha', 'zup')
        assert_raise(MockExpectationError) do
          @mock.yield_back
        end
      end
      
      def test_should_be_able_to_mock_object_methods_such_as_send
        @mock.should.receive(:send).with(:any_args)
        @mock.send 'hi'
        @mock.__verify
      end
      
      def test_should_be_able_to_raise_from_method_calling_yielding_mock
        @mock.should.receive(:yield_me).and_yield 44
        
        lambda do
          @mock.yield_me do |x|
            raise "Bang"
          end
        end.should_raise(StandardError)

        @mock.__verify
      end

    end
  end
end