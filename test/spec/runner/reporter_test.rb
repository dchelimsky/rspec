require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ReporterTest < Test::Unit::TestCase
      
      def setup
        @io = StringIO.new
        @backtrace_tweaker = Spec::Mocks::Mock.new("backtrace tweaker", :auto_verify => false)
        @formatter = Spec::Mocks::Mock.new("formatter", :auto_verify => false)
        @reporter = Reporter.new(@formatter, @backtrace_tweaker)
      end
      
      def test_should_push_time_to_reporter
        @formatter.should_receive(:start).with(5)
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary) do |time, a, b|
          assert_match(/[0-9].[0-9|e|-]+/, time.to_s)
        end
        @reporter.start(5)
        @reporter.end
        @reporter.dump
      end
      
      def test_should_push_stats_to_reporter_even_with_no_data
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 0, 0)
        @reporter.dump
      end
      
      def test_should_push_context_to_formatter
        @formatter.should_receive(:add_context).never
        @reporter.add_context "context"
      end
  
      def test_should_account_for_context_in_stats
        @formatter.should_receive(:add_context).with("context", true)
        @reporter.add_context "context"
      end
  
      def test_should_account_for_spec_in_stats_for_pass
        @formatter.should_receive(:spec_started)
        @formatter.should_receive(:spec_passed)
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 1, 0)
        @reporter.spec_started "spec"
        @reporter.spec_finished "spec"
        @reporter.dump
      end
  
      def test_should_account_for_spec_and_error_in_stats_for_pass
        @formatter.should_receive(:add_context)
        @formatter.should_receive(:spec_started).with("spec")
        @formatter.should_receive(:spec_failed).with("spec", 1, failure)
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_failure).with(1, :anything)
        @formatter.should_receive(:dump_summary).with(:anything, 1, 1)
        @backtrace_tweaker.should_receive(:tweak_backtrace)
        @reporter.add_context "context"
        @reporter.spec_started "spec"
        @reporter.spec_finished "spec", RuntimeError.new
        @reporter.dump
      end
      
      def test_should_handle_multiple_contexts_with_same_name
        @formatter.should_receive(:add_context).exactly(3).times
        @formatter.should_receive(:spec_started).exactly(3).times
        @formatter.should_receive(:spec_passed).exactly(3).times
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 3, 0)
        @reporter.add_context "context"
        @reporter.spec_started "spec 1"
        @reporter.spec_finished "spec 1"
        @reporter.add_context "context"
        @reporter.spec_started "spec 2"
        @reporter.spec_finished "spec 2"
        @reporter.add_context "context"
        @reporter.spec_started "spec 3"
        @reporter.spec_finished "spec 3"
        @reporter.dump
      end
  
      def test_should_handle_multiple_specs_same_name
        error = RuntimeError.new
        @formatter.should_receive(:add_context).exactly(2).times
        @formatter.should_receive(:spec_started).with("spec").exactly(4).times
        @formatter.should_receive(:spec_passed).with("spec").exactly(2).times
        @formatter.should_receive(:spec_failed).with("spec", 1, failure) 
        @formatter.should_receive(:spec_failed).with("spec", 2, failure)
        @formatter.should_receive(:dump_failure).exactly(2).times
        @formatter.should_receive(:start_dump)
        @formatter.should_receive(:dump_summary).with(:anything, 4, 2)
        @backtrace_tweaker.should_receive(:tweak_backtrace)
        @reporter.add_context "context"

        @reporter.spec_started "spec"
        @reporter.spec_finished "spec"

        @reporter.spec_started "spec"
        @reporter.spec_finished "spec", error

        @reporter.add_context "context"

        @reporter.spec_started "spec"
        @reporter.spec_finished "spec"

        @reporter.spec_started "spec"
        @reporter.spec_finished "spec", error

        @reporter.dump
      end
      
      def test_should_delegate_to_backtrace_tweaker
        @formatter.should_receive(:add_context)
        @formatter.should_receive(:spec_failed)
        @backtrace_tweaker.should_receive(:tweak_backtrace)
        @reporter.add_context "context"
        @reporter.spec_finished "spec", RuntimeError.new
        @backtrace_tweaker.__verify
      end

      def failure
        Mocks::DuckTypeArgConstraint.new(:header, :message, :backtrace)
      end

    end
  end
end