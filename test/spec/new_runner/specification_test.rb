require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class SpecificationTest < Test::Unit::TestCase
      
      def setup
        @reporter = Mock.new "reporter"
      end

      def test_should_run_spec_in_scope_of_execution_context
        spec = Specification.new("should pass") do
          self.should.not.be.instance_of Specification
          self.should.be.instance_of ExecutionContext
        end
        @reporter.should_receive(:spec_passed).with "should pass"
        spec.run @reporter
      end

      def test_should_add_itself_to_reporter_when_passes
        spec = Specification.new("spec") { }
        @reporter.should_receive(:spec_passed).with "spec"
        spec.run(@reporter)
      end

      def test_should_add_itself_to_reporter_when_fails
        error = RuntimeError.new
        spec = Specification.new("spec") { raise error }
        @reporter.should_receive(:spec_failed).with "spec", error
        spec.run(@reporter)
      end
      
      def test_should_run_several_setup_blocks
        spec = Specification.new("spec") do
          @setup_var_one.should.equal "one"
          @setup_var_two.should.equal "two"
        end
        setup_one = lambda {@setup_var_one = "one"}
        setup_two = lambda {@setup_var_two = "two"}
        @reporter.should_receive(:spec_passed).with "spec"
        spec.run @reporter, [setup_one, setup_two]
      end
      
      def test_should_verify_mocks_after_teardown
        spec = Specification.new("spec") do
          mock = mock("a mock")
          mock.should_receive(:poke)
        end
        @reporter.should_receive(:spec_failed) do |spec_name, error|
          spec_name.should.equal "spec"
          error.message.should.match /expected poke once, but received it 0 times/
        end
        spec.run @reporter
      end
      
      def teardown
        @reporter.__verify
      end
    end
  end
end