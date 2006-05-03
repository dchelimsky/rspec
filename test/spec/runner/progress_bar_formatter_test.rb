require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class ProgressBarFormatterTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @formatter = ProgressBarFormatter.new(@io)
      end

      def test_should_push_line_break_for_context
        @formatter.add_context("context", :ignored)
        assert_equal("\n", @io.string)
      end

      def test_should_push_dot_for_passing_spec
        @formatter.spec_passed("spec")
        assert_equal(".", @io.string)
      end

      def test_should_push_F_for_failing_spec
        @formatter.spec_failed("spec", 98)
        assert_equal("F", @io.string)
      end
      
      def test_should_produce_standard_summary
        @formatter.dump_summary(4,3,2,1)
        assert_equal("\nFinished in 4 seconds\n\n3 contexts, 2 specifications, 1 failure\n", @io.string)
      end

      def test_should_produce_line_break_on_start_dump
        @formatter.start_dump
        assert_equal("\n", @io.string)
      end
    end
    class ProgressBarFormatterDryRunTest < Test::Unit::TestCase
      def setup
        @io = StringIO.new
        @formatter = ProgressBarFormatter.new(@io, true)
      end
      
      def test_should_not_produce_summary_on_dry_run
        @formatter.dump_summary(4,3,2,1)
        assert_equal("", @io.string)
      end
    end
  end
end