require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextMatchingTest < Test::Unit::TestCase
      
      def setup
        @formatter = Spec::Mocks::Mock.new "formatter"
        @context = Context.new("context") {}
        @matcher = Spec::Mocks::Mock.new("matcher")
      end
      
      def test_should_use_spec_matcher
        @matcher.should_receive(:matches?).with("submitted spec")
        @context.specify("submitted spec") {}
        assert !@context.matches?("context with spec", @matcher)
      end

      def test_should_only_run_specified_specs_when_specified
        @context.specify("spec1") {}
        @context.specify("spec2") {}
        @context.run_single_spec "context spec1"
        assert_equal 1, @context.number_of_specs
      end
      
      def test_run_all_specs_when_spec_is_not_specified
        @context.specify("spec1") {}
        @context.specify("spec2") {}
        @context.run_single_spec "context"
        assert_equal 2, @context.number_of_specs
      end
      
    end
  end
end