require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class SpecificationTest < Test::Unit::TestCase
      
      def setup
        @reporter = Spec::Mocks::Mock.new "reporter"
      end

      def test_should_run_spec_in_scope_of_execution_context
        spec = Specification.new("should pass") do
          self.should_not_be_an_instance_of Specification
          self.should_be_an_instance_of ExecutionContext
        end
        @reporter.should_receive(:spec_started).with "should pass"
        @reporter.should_receive(:spec_finished).with "should pass", nil, nil
        spec.run @reporter
      end

      def test_should_add_itself_to_reporter_when_passes
        spec = Specification.new("spec") {}
        @reporter.should_receive(:spec_started).with "spec"
        @reporter.should_receive(:spec_finished).with "spec", nil, nil
        spec.run(@reporter)
      end

      def test_should_add_itself_to_reporter_when_fails
        error = RuntimeError.new
        spec = Specification.new("spec") { raise error }
        @reporter.should_receive(:spec_started).with "spec"
        @reporter.should_receive(:spec_finished).with "spec", error, "spec"
        spec.run(@reporter)
      end
      
      def test_should_add_itself_to_reporter_when_calling_run_dry
        spec = Specification.new("spec") {}
        @reporter.should_receive(:spec_started).with "spec"
        @reporter.should_receive(:spec_finished).with "spec"
        spec.run(@reporter, nil, nil, true)
      end

      def test_should_verify_mocks_after_teardown
        spec = Specification.new("spec") do
          mock = mock("a mock")
          mock.should_receive(:poke)
        end
        @reporter.should_receive(:spec_started).with "spec"
        @reporter.should_receive(:spec_finished) do |spec_name, error|
          spec_name.should_equal "spec"
          error.message.should_match(/expected 'poke' once, but received it 0 times/)
        end
        spec.run @reporter
      end

      def test_should_run_teardown_even_when_main_block_fails
        spec = Specification.new("spec") do
          raise "in body"
        end
        teardown = lambda do
          raise "in teardown"
        end
        @reporter.should_receive(:spec_started).with "spec"
        @reporter.should_receive(:spec_finished) do |spec, error, location|
          spec.should_equal "spec"
          location.should_equal "spec" 
          error.message.should_equal "in body"
        end
        spec.run @reporter, nil, teardown
      end
      
      def test_should_supply_setup_as_spec_name_if_failure_in_setup
        spec = Specification.new("spec") do
        end
        setup = lambda do
          raise "in setup"
        end
        @reporter.should_receive(:spec_started).with "spec"
        @reporter.should_receive(:spec_finished) do |name, error, location|
          name.should_equal "spec"
          error.message.should_equal "in setup"
          location.should_equal "setup"
        end
        spec.run @reporter, setup
      end
      
      def test_should_supply_teardown_as_failure_location_if_failure_in_teardown
        spec = Specification.new("spec") do
        end
        teardown = lambda do
          raise "in teardown"
        end
        @reporter.should_receive(:spec_started).with "spec"
        @reporter.should_receive(:spec_finished) do |name, error, location|
          name.should_equal "spec"
          error.message.should_equal "in teardown"
          location.should_equal "teardown"
        end
        spec.run @reporter, nil, teardown
      end
      
      def test_should_match_if_name_matches_end_of_input
        spec = Specification.new("spec")
        assert spec.matches_matcher?(SpecMatcher.new("context spec", "context"))
      end
      
      def test_should_match_if_name_matches_entire_input
        spec = Specification.new("spec")
        assert spec.matches_matcher?(SpecMatcher.new("spec", "context"))
      end
      
      def test_should_not_match_if_name_does_not_match
        spec = Specification.new("otherspec")
        assert !spec.matches_matcher?(SpecMatcher.new("context spec", "context"))
      end
      
      def teardown
        @reporter.__verify
      end
    end
  end
end