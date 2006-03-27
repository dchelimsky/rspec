require File.dirname(__FILE__) + '/../../test_helper'

class MockTest < Test::Unit::TestCase

  def setup
    @mock = Mock.new("test mock")
  end

  def test_should_report_line_number_of_expectaion_of_unreceived_message
    @mock.should_receive(:wont_happen).with("x", 3)

    begin
      @mock.__verify
    rescue Spec::Exceptions::MockExpectationError => e
      e.message.should.match /mock_test\.rb:10:in .test_should_report_line/
    end
    
  end

  def test_should_allow_block_to_calculate_return_values
    @mock.should_receive(:random_call).with("a","b","c").and_return { |a,b,c| c+b+a }
    assert_equal "cba", @mock.random_call("a","b","c")
    # TODO: remove __verify when migrating to self-hosting. Verify happens transparently in teardown. (AH)
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

  def test_should_test_multiple_calls_to_method_with_same_parameters
    @mock.should_receive(:random_call).twice.with("a","b","c")
    @mock.random_call("a","b","c")
    @mock.random_call("a","b","c")
    @mock.__verify
  end

  def test_should_raise_exception_if_parameters_dont_match_when_method_called
    @mock.should_receive(:random_call).with("a","b","c").and_return("booh")
    assert_raise(Spec::Exceptions::MockExpectationError) {
      @mock.random_call("a","d","c")
    }
  end
     
  def test_should_fail_if_unexpected_method_called
    assert_raise(Spec::Exceptions::MockExpectationError) {
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
    @mock.should_receive(:random_call).twice.with("a","b","c").and_return("booh")
    @mock.random_call("a","b","c")
    assert_raise(Spec::Exceptions::MockExpectationError) do
      @mock.__verify
    end
  end

  def test_should_use_block_for_expectation_if_provided
    @mock.should_receive(:random_call) do | a, b |
      a.should.equal("a")
      b.should.equal("b")
      "booh"
    end
    assert_equal("booh", @mock.random_call("a", "b"))
    @mock.__verify
  end
  
  def test_failing_expectation_block_throws
    @mock.should_receive(:random_call) {| a | a.should.be true}
    assert_raise(Spec::Exceptions::MockExpectationError) do
      @mock.random_call false
    end
  end
  
  def test_two_return_values
    @mock.should_receive(:multi_call).twice.with_no_args.and_return_consecutively([1, 2])
    assert_equal(1, @mock.multi_call)
    assert_equal(2, @mock.multi_call)
    @mock.__verify
  end
  
  def test_repeating_final_return_value
    @mock.should_receive(:multi_call).at_least_once.with_no_args.and_return_consecutively([1, 2])
    assert_equal(1, @mock.multi_call)
    assert_equal(2, @mock.multi_call)
    assert_equal(2, @mock.multi_call)
    @mock.__verify
  end
  
  def test_should_throw_on_call_of_never_method
    @mock.should_receive(:random_call).never
    assert_raise(Spec::Exceptions::MockExpectationError) do
      @mock.random_call
      @mock.__verify
    end
  end
  
  def test_should_throw_if_at_least_once_method_not_called
    @mock.should_receive(:random_call).at_least_once
    assert_raise(Spec::Exceptions::MockExpectationError) do
      @mock.__verify
    end
  end
  
  def test_should_not_throw_if_any_number_of_times_method_not_called
    @mock.should_receive(:random_call).any_number_of_times
    @mock.__verify
  end
  
  def test_should_not_throw_if_any_number_of_times_method_is_called
    @mock.should_receive(:random_call).any_number_of_times
    @mock.random_call
    @mock.__verify
  end
  
  def test_should_not_throw_if_at_least_once_method_is_called_twice
    @mock.should_receive(:random_call).at_least_once
    @mock.random_call
    @mock.random_call
    @mock.__verify
  end
  
  def test_should_support_mutiple_calls_with_different_args
    @mock.should_receive(:random_call).once.with(1)
    @mock.should_receive(:random_call).once.with(2)
    @mock.random_call(1)
    @mock.random_call(2)
    @mock.__verify
  end
  
  def test_should_support_multiple_calls_with_different_args_and_counts
    @mock.should_receive(:random_call).twice.with(1)
    @mock.should_receive(:random_call).once.with(2)
    @mock.random_call(1)
    @mock.random_call(2)
    @mock.random_call(1)
    @mock.__verify
  end
  
end
