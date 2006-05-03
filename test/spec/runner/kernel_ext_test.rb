require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class KernelExtTest < Test::Unit::TestCase
      def test_create_context
        assert_nothing_raised do
          context("") {}
        end
      end
    end
  end
end