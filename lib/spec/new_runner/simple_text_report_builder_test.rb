require 'test/unit'
require File.dirname(__FILE__) + '/context'
require File.dirname(__FILE__) + '/simple_text_report_builder'

class SimpleTextReportBuilderTest < Test::Unit::TestCase

  def setup
    @builder = SimpleTextReportBuilder.new
  end
  
  def test_should_output_stats_even_with_no_data
    assert_match(/Finished in 0.0 seconds/, @builder.text)
    assert_match(/0 contexts, 0 specifications, 0 failures/, @builder.text)
  end
  
  def test_should_account_for_context_in_stats
    @builder.add_context Spec::Context.new("context"){}
    assert_match(/1 context, 0 specifications, 0 failures/, @builder.text)
  end
  
  def test_should_return_one_dot_for_one_spec
    add_passing_spec("spec")
    assert_match(/.\n\n/, @builder.text)
    assert_match(/0 contexts, 1 specification, 0 failures/, @builder.text)
  end
  
  def test_should_return_one_F_for_one_failing_spec
    add_failing_spec("spec")
    assert_match(/F\n\n/, @builder.text)
    assert_match(/0 contexts, 1 specification, 1 failure/, @builder.text)
  end

  def test_should_return__dot_F_dot_for_a_failure_between_two_successes
    add_passing_spec("1")
    add_failing_spec("2")
    add_passing_spec("3")
    assert_match(/.F.\n\n/, @builder.text)
    assert_match(/0 contexts, 3 specifications, 1 failure/, @builder.text)
  end
  
  def test_should_return__F_dot_F_for_a_success_between_two_failures
    add_failing_spec("1")
    add_passing_spec("2")
    add_failing_spec("3")
    assert_match(/F.F\n\n/, @builder.text)
    assert_match(/0 contexts, 3 specifications, 2 failures/, @builder.text)
  end
  
  def test_should_include_time
    start = Time.new - 5
    stop = Time.new
    @builder.start_time = start
    @builder.end_time = stop
    assert_match(/Finished in 5.[0-9]+ seconds/, @builder.text)
  end

  def add_failing_spec(name)
    spec = Spec::Specification.new(name){raise}
    spec.run
    @builder.add_spec(spec)
  end

  def add_passing_spec(name)
    @builder.add_spec Spec::Specification.new(name){}
  end

end