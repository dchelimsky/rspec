require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class SpecdocFormatterTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @formatter = SpecdocFormatter.new(@io)
      end

      def test_should_push_context_name
        @formatter.add_context("context", :ignored)
        assert_equal("\ncontext\n", @io.string)
      end

      def test_should_push_passing_spec_name
        @formatter.spec_passed("spec")
        assert_equal("- spec\n", @io.string)
      end

      def test_should_push_failing_spec_name_and_failure_number
        @formatter.spec_failed("spec", 98)
        assert_equal("- spec (FAILED - 98)\n", @io.string)
      end

      def test_should_produce_standard_summary
        @formatter.dump_summary(4,3,2,1)
        assert_equal("\nFinished in 4 seconds\n\n3 contexts, 2 specifications, 1 failure\n", @io.string)
      end

      def test_should_push_nothing_on_start
        @formatter.start(5)
        assert_equal("", @io.string)
      end

      def test_should_push_nothing_on_start_dump
        @formatter.start_dump
        assert_equal("", @io.string)
      end

    end

    class SpecdocFormatterDryRunTest < Test::Unit::TestCase
      def setup
        @io = StringIO.new
        @formatter = SpecdocFormatter.new(@io, true)
      end
      
      def test_should_not_produce_summary_on_dry_run
        @formatter.dump_summary(4,3,2,1)
        assert_equal("", @io.string)
      end
    end
  end
end