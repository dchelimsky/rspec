require File.dirname(__FILE__) + '/../../test_helper'
require 'stringio'

module Spec
  module Runner
    class SimpleTextReporterTest < Test::Unit::TestCase
      
      def setup
        @io = StringIO.new
        @backtrace_tweaker = Spec::Api::Mock.new("backtrace tweaker")
        @reporter = SimpleTextReporter.new(@io, false, @backtrace_tweaker)
      end

      def test_should_include_time
        @reporter.start
        @reporter.end
        @reporter.dump
        assert_match(/Finished in [0-9].[0-9|e|-]+ seconds/, @io.string)
      end
      
      def test_should_output_stats_even_with_no_data
        @reporter.dump
        assert_match(/Finished in 0.0 seconds/, @io.string)
        assert_match(/0 contexts, 0 specifications, 0 failures/, @io.string)
      end
  
      def test_should_account_for_context_in_stats_for_pass
        @reporter.add_context "context", "calling line"
        @reporter.dump
        assert_match(/1 context, 0 specifications, 0 failures/, @io.string)
      end
  
      def test_should_account_for_spec_in_stats_for_pass
        @reporter.add_spec Specification.new("spec"), "calling line", {}
        @reporter.dump
        assert_match(/0 contexts, 1 specification, 0 failures/, @io.string)
      end
  
      def test_should_account_for_spec_and_error_in_stats_for_pass
        @backtrace_tweaker.should.receive(:tweak_backtrace)
        @reporter.add_context "context", "calling line"
        @reporter.add_spec Specification.new("spec"), "calling line", [RuntimeError.new]
        @reporter.dump
        assert_match(/1 context, 1 specification, 1 failure/, @io.string)
      end
      
      def test_should_handle_multiple_contexts_same_name
        @reporter.add_context Context.new("context") {}
        @reporter.add_context Context.new("context") {}
        @reporter.add_context Context.new("context") {}
        @reporter.dump
        assert_match(/3 contexts, 0 specifications, 0 failures/, @io.string)
      end
  
      def test_should_handle_multiple_specs_same_name
        @backtrace_tweaker.should.receive(:tweak_backtrace)
        @reporter.add_context "context", "calling line"
        @reporter.add_spec "spec", "calling line"
        @reporter.add_spec "spec", "calling line", [RuntimeError.new]
        @reporter.add_context "context", "calling line"
        @reporter.add_spec "spec", "calling line"
        @reporter.add_spec "spec", "calling line", [RuntimeError.new]
        @reporter.dump
        assert_match(/2 contexts, 4 specifications, 2 failures/, @io.string)
      end
      
      def test_should_delegate_to_backtrace_tweaker
        @backtrace_tweaker.should.receive(:tweak_backtrace)
        @reporter.add_context "context", "calling line"
        @reporter.add_spec "spec", "calling line", [RuntimeError.new]
        @backtrace_tweaker.__verify
      end

    end
    
    class FailureDumpTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = SimpleTextReporter.new(@io)
        @reporter.add_context "failing context", "calling line for context"
        @reporter.add_spec "failing spec", "calling line for spec", [RuntimeError.new]
        @reporter.dump
      end

      def test_should_include_context
        assert_match(/failing context/, @io.string)
      end

      def test_should_include_context_calling_line
        assert_match(/\[calling line for context\]/, @io.string)
      end

      def test_should_include_spec
        assert_match(/failing spec/, @io.string)
      end
      
      def test_should_include_spec_calling_line
        assert_match(/[calling line for spec]/, @io.string)
      end
      
    end

    class SimpleTextReporterQuietOutputTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = SimpleTextReporter.new(@io)
        @reporter.add_context "context", "calling line for context"
      end
      
      def test_should_remain_silent_when_context_name_provided
        assert_equal("\n", @io.string)
      end
      
      def test_should_output_dot_when_spec_passed
        @reporter.add_spec "spec", "calling line"
        assert_equal("\n.", @io.string)
      end

      def test_should_output_F_when_spec_failed
        @reporter.add_spec "spec", "calling line", [RuntimeError.new]
        assert_equal("\nF", @io.string)
      end
      
    end

    class SimpleTextReporterVerboseOutputTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = SimpleTextReporter.new(@io, true)
        @reporter.add_context "context", "calling line for context"
      end
      
      def test_should_output_when_context_name_provided
        assert_match(/\ncontext\n/, @io.string)
      end
      
      def test_should_output_spec_name_when_spec_passed
        @reporter.add_spec "spec", "calling line"
        assert_match(/- spec\n/, @io.string)
      end

      def test_should_output_failure_when_spec_failed
        @reporter.add_spec "spec", "calling line", [RuntimeError.new]
        assert_match(/spec \(FAILED - 1\)/, @io.string)
      end

    end
  end
end