require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class RdocFormatterTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @formatter = RdocFormatter.new(@io, true)
      end

      def test_should_push_out_context
        @formatter.add_context("context", :ignored)
        assert_equal("# context\n", @io.string)
      end

      def test_should_push_out_spec
        @formatter.spec_passed("spec")
        assert_equal("# * spec\n", @io.string)
      end

      def test_should_push_out_failed_spec
        @formatter.spec_failed("spec", 98, nil)
        assert_equal("# * spec [98 - FAILED]\n", @io.string)
      end
      
      def test_should_produce_no_summary
        @formatter.dump_summary(nil,nil,nil,nil)
        assert(@io.string.empty?)
      end

      def test_should_produce_nothing_on_start_dump
        @formatter.start_dump
        assert(@io.string.empty?)
      end

    end
    class RdocFormatterDryRunTest < Test::Unit::TestCase
      def setup
        @io = StringIO.new
        @formatter = RdocFormatter.new(@io, true)
      end
      
      def test_should_not_produce_summary_on_dry_run
        @formatter.dump_summary(4,3,2,1)
        assert_equal("", @io.string)
      end
    end
    
  end
end