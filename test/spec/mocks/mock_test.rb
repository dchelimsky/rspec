require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Mocks
    class MockTest < Test::Unit::TestCase

      def setup
        @mock = Mock.new("test mock")
      end

      def test_should_report_line_number_of_expectation_of_unreceived_message
        @mock.should_receive(:wont_happen).with("x", 3)
        #NOTE - this test is quite ticklish because it specifies that
        #the above statement appears on line 12 of this file.

        begin
          @mock.__verify
        rescue MockExpectationError => e
          e.backtrace[0].should_match(/mock_test\.rb:12:in .test_should_report_line/)
        end
    
      end
      
      def test_should_pass_when_not_receiving_message_specified_as_not_to_be_received
        @mock.should_not_receive(:not_expected)
        @mock.__verify
      end

      def test_should_pass_when_receiving_message_specified_as_not_to_be_received_with_different_args
        @mock.should_not_receive(:message).with("unwanted text")
        @mock.should_receive(:message).with("other text")
        @mock.message "other text"
        @mock.__verify
      end

      def test_should_fail_when_receiving_message_specified_as_not_to_be_received
        @mock.should_not_receive(:not_expected)
        @mock.not_expected
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def test_should_fail_when_receiving_message_specified_as_not_to_be_received_with_args
        @mock.should_not_receive(:not_expected).with("unexpected text")
        @mock.not_expected "unexpected text"
        assert_raise(MockExpectationError) do
          @mock.__verify
        end
      end

      def test_should_allow_block_to_calculate_return_values
        @mock.should_receive(:random_call).with("a","b","c").and_return { |a,b,c| c+b+a }
        assert_equal "cba", @mock.random_call("a","b","c")
        @mock.__verify
      end

      def test_should_allow_parameter_as_return_value
        @mock.should_receive(:random_call).with("a","b","c").and_return("booh")
        assert_equal "booh", @mock.random_call("a","b","c")
        @mock.__verify
      end

      def test_return_nil_if_no_return_value_set
        @mock.should_receive(:random_call).with("a","b","c")
        assert_nil @mock.random_call("a","b","c")
        @mock.__verify
      end

      def test_should_raise_exception_if_parameters_dont_match_when_method_called
        @mock.should_receive(:random_call).with("a","b","c").and_return("booh")
        assert_raise(MockExpectationError) {
          @mock.random_call("a","d","c")
        }
      end
     
      def test_should_fail_if_unexpected_method_called
        assert_raise(MockExpectationError) {
          @mock.random_call("a","d","c")
        }
      end
  
      def test_should_use_block_for_expectation_if_provided
        @mock.should_receive(:random_call) do | a, b |
          a.should_equal "a"
          b.should_equal "b"
          "booh"
        end
        assert_equal("booh", @mock.random_call("a", "b"))
        @mock.__verify
      end
  
      def test_should_fail_if_expectation_block_fails
        @mock.should_receive(:random_call).with(true)# {| a | a.should_be true}
        assert_raise(MockExpectationError) do
          @mock.random_call false
        end
      end
  
      def test_should_fail_when_method_defined_as_never_is_received
        @mock.should_receive(:random_call).never
        assert_raise(MockExpectationError) do
          @mock.random_call
          @mock.__verify
        end
      end
      
      def test_should_raise_when_told_to
        @mock.should_receive(:random_call).and_raise(RuntimeError)
        assert_raise(RuntimeError) do
          @mock.random_call
        end
      end
 
      def test_should_not_raise_when_told_to_if_args_dont_match
        @mock.should_receive(:random_call).with(2).and_raise(RuntimeError)
        assert_raise(MockExpectationError) do
          @mock.random_call 1
        end
      end
 
      def test_should_throw_when_told_to
        @mock.should_receive(:random_call).and_throw(:blech)
        assert_throws(:blech) do
          @mock.random_call
        end
      end

      def test_should_raise_when_explicit_return_and_block_constrained
        assert_raise(AmbiguousReturnError) {
          @mock.should_receive(:fruit) {|colour|
            :strawberry
          }.and_return :apple
        }
      end
      
      def TODO_test_should_use_past_tense
        @mock.should_have_received(:hello)
      end

      def TODO_test_should_sent
        cut.should_have_sent(:hello)
        cut.should_have_sent(:hello).to(@mock)
      end
     
      def test_should_ignore_args_on_any_args
        @mock.should_receive(:random_call).at_least(:once).with(:any_args)
        @mock.random_call
        @mock.random_call 1
        @mock.random_call "a", 2
        @mock.random_call [], {}, "joe", 7
        @mock.__verify
      end
      
      def test_should_fail_on_no_args_if_any_args_received
        @mock.should_receive(:random_call).with(:no_args)
        assert_raise(MockExpectationError) do
          @mock.random_call 1
        end
      end
      
      def test_should_yield_single_value
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield(99)
        a = nil
        @mock.yield_back {|a|}
        a.should_equal 99
        @mock.__verify
      end

      def test_should_yield_two_values
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield('wha', 'zup')
        a, b = nil
        @mock.yield_back {|a,b|}
        a.should_equal 'wha'
        b.should_equal 'zup'
        @mock.__verify
      end

      def test_should_fail_when_calling_yielding_method_with_wrong_arity
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield('wha', 'zup')
        assert_raise(MockExpectationError) do
          @mock.yield_back {|a|}
        end
      end

      def test_should_fail_when_calling_yielding_method_without_block
        @mock.should_receive(:yield_back).with(:no_args).once.and_yield('wha', 'zup')
        assert_raise(MockExpectationError) do
          @mock.yield_back
        end
      end
      
      def test_should_be_able_to_mock_send
        @mock.should_receive(:send).with(:any_args)
        @mock.send 'hi'
        @mock.__verify
      end
      
      def test_should_be_able_to_raise_from_method_calling_yielding_mock
        @mock.should_receive(:yield_me).and_yield 44
        
        lambda do
          @mock.yield_me do |x|
            raise "Bang"
          end
        end.should_raise(StandardError)

        @mock.__verify
      end

      def test_should_use_a_list_of_return_values_for_successive_calls
        @mock.should_receive(:multi_call).twice.with(:no_args).and_return([8, 12])
        assert_equal(8, @mock.multi_call)
        assert_equal(12, @mock.multi_call)
        @mock.__verify
      end

      def test_verify_should_clear_expectations
        @mock.should_receive(:foobar)
        @mock.foobar
        @mock.__verify
        assert_raises Spec::Mocks::MockExpectationError do
          @mock.foobar
        end
      end
      
      def test_should_verify_if_auto_verify_set_to_true
        reporter = Spec::Mocks::Mock.new("reporter", :null_object => true)
        reporter.should_receive(:spec_finished) do |name, error, location|
          error.to_s.should_match /expected 'abcde' once, but received it 0 times/
        end
        Runner::Specification.new("spec") do
          mock = Spec::Mocks::Mock.new("mock", :auto_verify => true)
          mock.should_receive(:abcde)
        end.run reporter
        reporter.__verify
      end

      def test_should_verify_if_auto_verify_not_set_explicitly
        reporter = Spec::Mocks::Mock.new("reporter", :null_object => true)
        reporter.should_receive(:spec_finished) do |name, error, location|
          error.to_s.should_match /expected 'abcde' once, but received it 0 times/
        end
        Runner::Specification.new("spec") do
          mock = Spec::Mocks::Mock.new("mock")
          mock.should_receive(:abcde)
        end.run reporter
        reporter.__verify
      end

      def test_should_not_verify_if_auto_verify_set_false
        reporter = Spec::Mocks::Mock.new("reporter", :null_object => true)
        reporter.should_receive(:spec_finished) do |name, error, location|
          error.should_be_nil
        end
        Runner::Specification.new("spec") do
          mock = Spec::Mocks::Mock.new("mock", :auto_verify => false)
          mock.should_receive(:abcde)
        end.run reporter
        reporter.__verify
      end
    end
  end
end