require 'test/unit'

require 'spec'


class FixtureTestingContext < Spec::Context

  @setup_called = false
  @spec_called = false
  @teardown_called = false
  
  def setup
    @setup_called = true
  end
  
  def verify_setup
    @setup_called
  end
  
  def teardown
    @teardown_called = true
  end

  def verify_teardown
    @teardown_called
  end
  
  def specification
    @spec_called = true
  end

  def verify_spec
    @spec_called
  end

end


class NullResultListener

  def pass(spec)
  end

  def failure(spec)
  end

  def error(spec)
  end

  def spec(spec)
  end

end


class ContextFixturesTest < Test::Unit::TestCase

  def setup
    @fixture_testing_context = FixtureTestingContext.new(:specification)
    @fixture_testing_context.run(NullResultListener.new)
  end
  
  def test_should_run_setup_before
    @fixture_testing_context.verify_setup
  end
  
  def test_should_run_teardown_after
    @fixture_testing_context.verify_teardown
  end

end
