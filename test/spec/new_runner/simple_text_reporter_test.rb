require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class SimpleTextReporterTest < Test::Unit::TestCase
      
      def setup
        @io = StringIO.new
        @reporter = SimpleTextFormatter.new(@io)
      end

      def test_should_include_time
        start = Time.new - 5
        stop = Time.new
        @reporter.start_time = start
        @reporter.end_time = stop
        @reporter.dump
        assert_match(/Finished in 5.[0-9]+ seconds/, @io.string)
      end
      
      def test_should_ask_context_to_describe_itself_when_started
        context = Mock.new("context")
        context.should_receive(:describe).with @reporter
        @reporter.context_started context
        context.__verify
      end

      def test_should_ask_spec_to_describe_itself_when_passed
        spec = Mock.new("spec")
        spec.should_receive(:describe_success).with @reporter
        @reporter.spec_passed spec
        spec.__verify
      end

      def test_should_ask_spec_to_describe_itself_when_failed
        spec = Mock.new("spec")
        spec.should_receive(:describe_failure).with @reporter
        @reporter.spec_failed spec, nil
        spec.__verify
      end
      
      def test_should_output_nothing_when_context_ended
        @reporter.context_ended nil
        assert_equal("", @io.string)
      end
      
      def test_should_output_stats_even_with_no_data
        @reporter.dump
        assert_match(/Finished in 0.0 seconds/, @io.string)
        assert_match(/0 contexts, 0 specifications, 0 failures/, @io.string)
      end
  
      def test_should_account_for_context_in_stats_for_pass
        @reporter.context_started Context.new("context") {}
        @reporter.dump
        assert_match(/1 context, 0 specifications, 0 failures/, @io.string)
      end
  
      def test_should_account_for_spec_in_stats_for_pass
        @reporter.spec_passed Specification.new("spec", nil) {}
        @reporter.dump
        assert_match(/0 contexts, 1 specification, 0 failures/, @io.string)
      end
  
      def test_should_account_for_spec_and_error_in_stats_for_pass
        @reporter.spec_failed Specification.new("spec", nil), RuntimeError.new
        @reporter.dump
        assert_match(/0 contexts, 1 specification, 1 failure/, @io.string)
      end
  
    end

    class SimpleTextReporterQuietOutputTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = SimpleTextFormatter.new(@io)
      end
      
      def test_should_remain_silent_when_context_name_provided
        @reporter.context_name "context"
        assert_equal("", @io.string)
      end
      
      def test_should_output_dot_when_spec_passed
        @reporter.spec_name "spec"
        assert_equal(".", @io.string)
      end

      def test_should_output_F_when_spec_failed
        @reporter.spec_name "spec", RuntimeError.new
        assert_equal("F", @io.string)
      end

    end


    class SimpleTextReporterVerboseOutputTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @reporter = SimpleTextFormatter.new(@io, true)
      end
      
      def test_should_output_when_context_name_provided
        @reporter.context_name "context"
        assert_equal("context\n", @io.string)
      end
      
      def test_should_output_spec_name_when_spec_passed
        @reporter.spec_name "spec"
        assert_equal("- spec\n", @io.string)
      end

      def test_should_output_failure_when_spec_failed
        error = RuntimeError.new
        begin
          raise error
        rescue
        end
        @reporter.spec_name "spec", error
        assert_equal("- spec (FAILED)\n#{error.backtrace.join("\n")}\n\n", @io.string)
      end

    end
  end
end