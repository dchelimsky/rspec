require File.dirname(__FILE__) + '/../../test_helper'
require 'stringio'

class SimpleTextFormatterTest < Test::Unit::TestCase

  def setup
    @out = String.new
    @formatter = SimpleTextFormatter.new(@out)
  end
  
  def test_should_output_stats_even_with_no_data
    @formatter.dump
    assert_match(/Finished in 0.0 seconds/, @out)
    assert_match(/0 contexts, 0 specifications, 0 failures/, @out)
  end
  
  def test_should_account_for_context_in_stats_for_pass
    @formatter.pass("context", "spec")
    @formatter.dump
    assert_match(/1 context, 1 specification, 0 failures/, @out)
  end
  
  def test_should_account_for_context_in_stats_for_fail
    @formatter.fail("context", "spec", RuntimeError.new)
    @formatter.dump
    assert_match(/1 context, 1 specification, 1 failure/, @out)
  end
  
  def test_should_include_time
    start = Time.new - 5
    stop = Time.new
    @formatter.start_time = start
    @formatter.end_time = stop
    @formatter.dump
    assert_match(/Finished in 5.[0-9]+ seconds/, @out)
  end
  
  def test_pass_should_put_dot_to_output
    @formatter.pass("context", "name")
    assert_equal("\n.", @out)
  end

  def test_fail_should_put_dot_to_output
    error = RuntimeError.new
    @formatter.fail("context", "spec", error)
    assert_equal("\nF", @out)
  end

end

class SimpleTextFormatterInVerboseModeTest < Test::Unit::TestCase

  def setup
    @out = StringIO.new
    @formatter = SimpleTextFormatter.new(@out, true)
  end
  
  def test_should_print_context_and_spec_on_first_pass
    @formatter.pass("test context", "test spec")
    assert_equal("\ntest context\n- test spec\n", @out.string)
  end
  
  def test_should_print_context_and_spec_on_first_fail
    @formatter.fail("test context", "test spec", nil)
    assert_equal("\ntest context\n- test spec (FAILED - 1)\n", @out.string)
  end
  
  def test_should_not_print_context_on_second_pass
    @formatter.pass("test context", "test spec1")
    @formatter.pass("test context", "test spec2")
    assert_equal("\ntest context\n- test spec1\n- test spec2\n", @out.string)
  end
  
  def test_should_not_print_context_on_second_fail
    @formatter.fail("test context", "test spec1", nil)
    @formatter.fail("test context", "test spec2", nil)
    assert_equal("\ntest context\n- test spec1 (FAILED - 1)\n- test spec2 (FAILED - 2)\n", @out.string)
  end
  
  def test_should_include_spaces_between_specs
    @formatter.pass("test context 1", "test spec 2")
    @formatter.fail("test context 3", "test spec 4", nil)
    expected = <<-EXPECTED

test context 1
- test spec 2

test context 3
- test spec 4 (FAILED - 1)
    EXPECTED
    assert_equal(expected, @out.string)
  end
  
end