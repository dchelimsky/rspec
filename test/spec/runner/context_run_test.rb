require 'test/unit'

require 'spec'


class TestCon < Spec::Context

  def empty_specification
  end

  def passing_once_specification
    true.should.equal(true)
  end
  
  def failing_once_specification
    false.should.equal(true)
  end
  
  def erroring_once_specification
    undefined_method.should.equal(true)
  end
  
  def passing_multi_specification
    true.should.equal(true)
    false.should.equal(false)
    Object.should.equal(Object)
  end

  def failing_multi_specification
    false.should.equal(true)
    true.should.equal(false)
    false.should.equal(nil)
  end

  def erroring_multi_specification
    undefined_method.should.equal(false)
    undefined_method.should.not.equal(true)
  end

end


class MockResultListener

  def initialize
    @pass_count = 0
    @failure_count = 0
    @spec_count = 0
  end

  def pass(spec)
    @pass_count += 1
  end

  def failure(spec, exception)
    @failure_count += 1
  end

  def spec(spec)
    @spec_count += 1
  end
  
  def verify_failures(count)
    check(count, @failure_count) 
  end

  def verify_passes(count)
    check(count, @pass_count)
  end

  def verify_specs(count)
    check(count, @spec_count)
  end
  
  def check(expected, actual)
    if (expected != actual) 
      raise Test::Unit::AssertionFailedError.new("expected: " + expected.to_s + " actual: " + actual.to_s)
    end
  end

end


class ContextRunPassingOnceTest < Test::Unit::TestCase

  def setup
    @context = TestCon.new(:passing_once_specification)
    @result_listener = MockResultListener.new
    @context.run(@result_listener)
  end
  
  def test_should_have_one_pass
    @result_listener.verify_passes(1)
  end
  
  def test_should_have_no_failures
    @result_listener.verify_failures(0)
  end

  def test_should_have_one_expectation
    @result_listener.verify_specs(1)
  end

end


class ContextRunFailingOnceTest < Test::Unit::TestCase

  def setup
    @context = TestCon.new(:failing_once_specification)
    @result_listener = MockResultListener.new
    @context.run(@result_listener)
  end

  def test_should_have_one_failure
    @result_listener.verify_failures(1)
  end
  
  def test_should_have_no_passes
    @result_listener.verify_passes(0)
  end

  def test_should_have_one_expectation
    @result_listener.verify_specs(1)
  end

end


class ContextRunErroringTest < Test::Unit::TestCase

  def setup
    @context = TestCon.new(:erroring_once_specification)
    @result_listener = MockResultListener.new
    @context.run(@result_listener)
  end
  
  def test_should_have_one_failures
    @result_listener.verify_failures(1)
  end
  
  def test_should_have_no_passes
    @result_listener.verify_passes(0)
  end

  def test_should_have_one_spec
    @result_listener.verify_specs(1);
  end

end


class ContextRunFailingMultipleTest <Test::Unit::TestCase

  def test_should_have_one_expectation
    @context = TestCon.new(:failing_multi_specification)
    @result_listener = MockResultListener.new
    @context.run(@result_listener)
    @result_listener.verify_specs(1)
  end

end


class ContextRunErroringMultipleTest < Test::Unit::TestCase

  def test_should_have_no_expectations
    @context = TestCon.new(:erroring_multi_specification)
    @result_listener = MockResultListener.new
    @context.run(@result_listener)
    @result_listener.verify_specs(1)
  end
  
end
