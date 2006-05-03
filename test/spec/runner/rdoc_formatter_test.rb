require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class RdocFormatterTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @formatter = RdocFormatter.new(@io, false)
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
        @formatter.spec_failed("spec", 98)
        assert_equal("# * spec [98 - FAILED]\n", @io.string)
      end

    end
  end
end