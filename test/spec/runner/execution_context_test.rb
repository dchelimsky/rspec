require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ExecutionContextTest < Test::Unit::TestCase

      def test_violated
        assert_raise(Spec::Expectations::ExpectationNotMetError) do
          ExecutionContext.new(nil).violated
        end
      end
      
      def test_duck_type
        ec = ExecutionContext.new(Spec::Mocks::Mock.new("spec", :null_object => true))
        duck_type = ec.duck_type(:length)
        assert duck_type.is_a?(Spec::Mocks::DuckTypeArgConstraint)
        assert duck_type.matches?([])
      end
    end
  end
end