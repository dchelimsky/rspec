require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class SpecificationTest < Test::Unit::TestCase
      
      def setup
        @reporter = Mock.new "reporter"
      end

      def test_should_run_spec_in_different_scope_than_exception
        spec = Specification.new("context","should pass") do
          self.should.not.be.instance_of Specification
          self.should.be.instance_of Object
        end
        @reporter.should_receive(:spec_passed).with spec
        spec.run @reporter
      end

      def test_should_add_itself_to_reporter_when_passes
        spec = Specification.new("context","should pass") { true }
        @reporter.should_receive(:spec_passed).with spec
        spec.run(@reporter)
      end

      def test_should_add_itself_to_reporter_when_fails
        error = RuntimeError.new
        spec = Specification.new("context","should pass") { raise error }
        @reporter.should_receive(:spec_failed).with spec, error
        spec.run(@reporter)
      end
      
      def test_should_provide_name_upon_receipt_of_describe_success_message
        spec = Specification.new("context","spec") {}
        @reporter.should_receive(:spec_name).with("spec")
        spec.describe_success(@reporter)
      end
      
      def test_should_provide_name_and_exception_upon_receipt_of_describe_failure_message
        spec = Specification.new("context","spec") {}
        error = NotImplementedError.new
        spec.instance_variable_set "@error", error
        @reporter.should_receive(:spec_name).with("spec", error)
        spec.describe_failure(@reporter)
      end
      
      def teardown
        @reporter.__verify
      end
    end
  end
end