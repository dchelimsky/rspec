require 'test/unit'

require 'spec'

class PassingCon < Spec::Context

  def ex1
    true.should_be_true
  end

  def ex2
    true.should_be_true
  end

  def ex3
    true.should_be_true
  end

end


class FailingCon < Spec::Context

  def fail1
    false.should_be_true
  end

  def fail2
    false.should_be_true
  end

  def fail3
    false.should_be_true
  end

end


class ErringCon < Spec::Context

  def error1
    raise "boom"
  end

  def error2
    raise "boom"
  end

  def error3
    raise "boom"
  end

end


class TestTextRunner < Test::Unit::TestCase

  def setup
    @buffer = String.new
    @runner = Spec::TextRunner.new(@buffer)
  end

  def test_passing_example_outputs_period
    @runner.run(PassingCon)
    assert_buffer_includes("...")
  end

  def test_failing_example_outputs_X
    @runner.run(FailingCon)
    assert_buffer_includes("XXX")
  end

  def test_erring_example_outputs_X
    @runner.run(ErringCon)
    assert_buffer_includes("XXX")
  end
  
  def test_failure_backtrace
    @runner.run(FailingCon)
    assert_buffer_includes("1)")
    assert_buffer_includes("in `fail1'")
    assert_buffer_includes("2)")
    assert_buffer_includes("in `fail2'")
    assert_buffer_includes("3)")
    assert_buffer_includes("in `fail3'")
  end

  def test_error_backtrace
    @runner.run(ErringCon)
    assert_buffer_includes "1)"
    assert_buffer_includes "in `error1'"
    assert_buffer_includes "2)"
    assert_buffer_includes "in `error2'"
    assert_buffer_includes "3)"
    assert_buffer_includes "in `error3'"
  end

  def test_summary_with_no_failures
    @runner.run(PassingCon)
    assert_buffer_includes "3 specifications, 0 failures"
  end
  
	def test_should_run_all_specifications
		@runner.run(Spec::Collector)
		assert_buffer_includes "9 specifications, 6 failures"
	end

	def test_should_run_all_specifications_when_no_args_provided
		@runner.run
		assert_buffer_includes "9 specifications, 6 failures"
	end

  def test_should_only_report_first_failure
    ex = Spec::Exceptions::ExpectationNotMetError.new("1")
    ex.set_backtrace(["1", "2"])
    @runner.start_run
    @runner.spec(nil)
    @runner.failure(nil, ex)
    @runner.failure(nil, ex)
    @runner.end_run
    assert_buffer_includes "1 specifications, 1 failure"
  end

  def test_should_only_report_first_failure_over_multiple_specs
    ex = Spec::Exceptions::ExpectationNotMetError.new("1")
    ex.set_backtrace(["1", "2"])
    @runner.start_run
    @runner.spec(nil)
    @runner.failure(nil, ex)
    @runner.failure(nil, ex)
    @runner.spec(nil)
    @runner.failure(nil, ex)
    @runner.failure(nil, ex)
    @runner.end_run
    assert_buffer_includes "2 specifications, 2 failure"
  end

  def assert_buffer_includes(substring)
    assert(@buffer.include?(substring), _buffer_message(substring))
  end

  def _buffer_message(substring)
    "Expected substring <" + substring + "> Buffer was <" + @buffer + ">"
  end
  
end
