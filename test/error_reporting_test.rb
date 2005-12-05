require 'test/unit'

require 'spec'


class ErrorReportingContext < Spec::Context

  # should

  def use_the_standard_message_for_should
    Object.should { false == true }
  end

  def use_the_provided_message_for_should
    Object.should("provided message") { false == true }
  end
  
  # should_equal

  def use_the_standard_message_for_should_equal
    Object.should_equal Class
  end

  def use_the_provided_message_for_should_equal
    Object.should_equal(Class, "provided for should_equal")
  end

  # should_not_equal

  def use_the_standard_message_for_should_not_equal
    Object.should_not_equal Object
  end

  def use_the_provided_message_for_should_not_equal
    Object.should_not_equal(Object, "provided for should_not_equal")
  end

  # should_be_nil
  
  def use_the_standard_message_for_should_be_nil
    Object.should_be_nil
  end

  def use_the_provided_message_for_should_be_nil
    Object.should_be_nil("provided for should_be_nil")
  end

  # should_not_be_nil
  
  def use_the_standard_message_for_should_not_be_nil
    nil.should_not_be_nil
  end

  def use_the_provided_message_for_should_not_be_nil
    nil.should_not_be_nil("provided for should_not_be_nil")
  end

  # should_be_empty
  
  def use_the_standard_message_for_should_be_empty
    ['foo', 'bar'].should_be_empty
  end
  
  def use_the_provided_message_for_should_be_empty
    ['foo', 'bar'].should_be_empty("provided for should_be_empty")
  end

  # should_not_be_empty
  
  def use_the_standard_message_for_should_not_be_empty
    [].should_not_be_empty
  end

  def use_the_provided_message_for_should_not_be_empty
    [].should_not_be_empty("provided for should_not_be_empty")
  end

  # should_include
  
  def use_the_standard_message_for_should_include
    ['foo'].should_include('bar')
  end

  def use_the_provided_message_for_should_include
    ['foo'].should_include('bar', "provided for should_include")
  end

  # should_not_include
  
  def use_the_standard_message_for_should_not_include
    ['foo'].should_not_include('foo')
  end

  def use_the_provided_message_for_should_not_include
    ['foo'].should_not_include('foo', "provided for should_not_include")
  end

  # should_be_true
  
  def use_the_standard_message_for_should_be_true
    false.should_be_true
  end

  def use_the_provided_message_for_should_be_true
    false.should_be_true("provided for should_be_true")
  end

  # should_be_false
  
  def use_the_standard_message_for_should_be_false
    true.should_be_false
  end
  
  def use_the_provided_message_for_should_be_false
    true.should_be_false("provided for should_be_false")
  end

end


class ErrorReportingRunner

  def initialize
    @failures = []
  end

  def pass(spec)
  end

  def failure(spec, exception)
    @failures << exception.message
  end

  def error(spec)
  end

  def spec(spec)
  end

  def run(context)
    context.specifications.each do |example|
      the_context = context.new(example)
      the_context.run(self)
    end
  end

  def dump_failures
    @failures
  end

end


class ErrorReportingTest < Test::Unit::TestCase

  def setup
    @runner = ErrorReportingRunner.new
    @runner.run(ErrorReportingContext)
  end

  # should

  def test_should_report_standard_message_for_should
    assert @runner.dump_failures.include?("Expectation not met.")
  end

  def test_should_report_provided_message_for_should
    assert @runner.dump_failures.include?("provided message")
  end  

  # should_equal
  
  def test_should_report_standard_message_for_should_equal
    assert @runner.dump_failures.include?("<Object:Class>\nshould be equal to:\n<Class:Class>"), @runner.dump_failures
  end

  def test_should_report_provided_message_for_should_equal
    assert @runner.dump_failures.include?("provided for should_equal"), @runner.dump_failures
  end

  # should_not_equal
  
  def test_should_report_standard_message_for_should_not_equal
    assert @runner.dump_failures.include?("<Object:Class>\nshould not be equal to:\n<Object:Class>"), @runner.dump_failures
  end
  
  def test_should_report_provided_message_for_should_not_equal
    assert @runner.dump_failures.include?("provided for should_not_equal"), @runner.dump_failures
  end
  
  # should_be_nil
  
  def test_should_report_standard_message_for_should_be_nil
    assert @runner.dump_failures.include?("<Object> should be nil")
  end
  
  def test_should_report_provided_message_fro_should_be_nil
    assert @runner.dump_failures.include?("provided for should_be_nil")
  end
  
  # should_not_be_nil

  def test_should_report_standard_message_for_should_not_be_nil
    assert @runner.dump_failures.include?("<> should not be nil")
  end
  
  def test_should_report_provided_message_for_should_not_be_nil
    assert @runner.dump_failures.include?("provided for should_not_be_nil")
  end

  # should_be_empty
  
  def test_should_report_standard_message_for_should_be_empty
    assert @runner.dump_failures.include?('<["foo", "bar"]> should be empty')
  end
  
  def test_should_report_provided_message_for_should_be_empty
    assert @runner.dump_failures.include?("provided for should_be_empty")
  end
  
  # should_not_be_empty

  def test_should_report_standard_message_for_should_not_be_empty
    assert @runner.dump_failures.include?("<[]> should not be empty")
  end
  
  def test_should_report_provided_message_for_should_not_be_empty
    assert @runner.dump_failures.include?("provided for should_not_be_empty")
  end

  # should_include
  
  def test_should_report_standard_message_for_should_include
    assert @runner.dump_failures.include?('<["foo"]> should include <"bar">')
  end
  
  def test_should_report_provided_message_for_should_include
    assert @runner.dump_failures.include?("provided for should_include")
  end
  
  # should_not_include

  def test_should_report_standard_message_for_should_not_include
    assert @runner.dump_failures.include?('<["foo"]> should not include <"foo">')
  end

  def test_should_report_provided_message_for_should_not_include
    assert @runner.dump_failures.include?("provided for should_not_include")
  end
  
  # should_be_true

  def test_should_report_standard_message_for_should_be_true
    assert @runner.dump_failures.include?("<false> should be true")
  end

  def test_should_report_provided_message_for_should_be_true
    assert @runner.dump_failures.include?("provided for should_be_true")
  end
  
  # should_be_false

  def test_should_report_standard_message_for_should_be_false
    assert @runner.dump_failures.include?("<true> should be false")
  end

  def test_should_report_provided_message_for_should_be_false
    assert @runner.dump_failures.include?("provided for should_be_false")
  end

end
