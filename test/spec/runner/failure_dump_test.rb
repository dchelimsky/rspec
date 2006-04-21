require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    
      class FailureDumpTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = SimpleTextReporter.new(@io)
        @reporter.add_context "context"
      end
    
      def test_should_begin_failure_with_informational_headline
        error = Spec::Api::ExpectationNotMetError.new
        @reporter.add_context "context"
        @reporter.add_spec "spec", [error], "spec"
        @reporter.dump
        assert_match(/ExpectationNotMetError in 'context spec'/, @io.string)
      end
      
      def test_should_include_context_and_spec_name_in_backtrace
        error = RuntimeError.new
        error.set_backtrace ["/a/b/c/d/e.rb:34 in `__instance_exec'"]
        @reporter.add_spec "spec", [error], "spec"
        @reporter.dump_errors
        assert_match(/context spec/, @io.string)
      end

    def test_should_include_context_and_setup_in_backtrace_if_error_in_setup
      error = RuntimeError.new
      error.set_backtrace ["/a/b/c/d/e.rb:34 in `__instance_exec'"]
      @reporter.add_spec "spec", [error], "setup"
      @reporter.dump_errors
      assert_match(/context \[setup\]/, @io.string)
    end

    def test_should_include_context_and_teardown_in_backtrace_if_error_in_teardown
      error = RuntimeError.new
      error.set_backtrace ["/a/b/c/d/e.rb:34 in `__instance_exec'"]
      @reporter.add_spec "spec", [error], "teardown"
      @reporter.dump_errors
      assert_match(/context \[teardown\]/, @io.string)
    end

    end

  end 
end