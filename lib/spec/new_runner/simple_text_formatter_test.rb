require 'test/unit'
require File.dirname(__FILE__) + '/context'
require File.dirname(__FILE__) + '/simple_text_formatter'

class SimpleTextFormatterTest < Test::Unit::TestCase

  def setup
    @out = String.new
    @builder = SimpleTextFormatter.new(@out)
  end
  
  def test_should_output_stats_even_with_no_data
    @builder.dump
    assert_match(/Finished in 0.0 seconds/, @out)
    assert_match(/0 contexts, 0 specifications, 0 failures/, @out)
  end
  
  def test_should_account_for_context_in_stats
    @builder.add_context_name "context"
    @builder.dump
    assert_match(/1 context, 0 specifications, 0 failures/, @out)
  end
  
  def test_should_include_time
    start = Time.new - 5
    stop = Time.new
    @builder.start_time = start
    @builder.end_time = stop
    @builder.dump
    assert_match(/Finished in 5.[0-9]+ seconds/, @out)
  end
  
  def test_pass_should_put_dot_to_output
    @builder.pass("name")
    assert_equal(".", @out)
  end

  def test_fail_should_put_dot_to_output
    @builder.fail("name")
    assert_equal("F", @out)
  end

  def add_failing_spec(name)
    @builder.add_spec_name(name)
    @builder.add_failure(name, RuntimeError.new)
  end

  def add_passing_spec(name)
    @builder.add_spec_name name
  end

end