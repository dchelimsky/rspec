require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class RDocOutputterTest < Test::Unit::TestCase

      def setup
        @io = StringIO.new
        @formatter = RDocOutputter.new(@io)
      end

      def test_should_push_out_context
        @formatter.add_context("context")
        assert_equal("# context\n", @io.string)
      end

      def test_should_push_out_spec
        @formatter.add_spec("spec")
        assert_equal("# * spec\n", @io.string)
      end

    end
  end
end