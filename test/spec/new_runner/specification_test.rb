require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class SpecificationTest < Test::Unit::TestCase
      
      def setup
        @reporter = Api::Mock.new "reporter"
      end

      def test_should_run_spec_in_scope_of_execution_context
        spec = Specification.new("should pass") do
          self.should.not.be.instance_of Specification
          self.should.be.instance_of ExecutionContext
        end
        @reporter.should_receive(:add_spec).with "should pass", []
        spec.run @reporter
      end

      def test_should_add_itself_to_reporter_when_passes
        spec = Specification.new("spec") {}
        @reporter.should_receive(:add_spec).with "spec", []
        spec.run(@reporter)
      end

      def test_should_add_itself_to_reporter_when_fails
        error = RuntimeError.new
        spec = Specification.new("spec") { raise error }
        @reporter.should_receive(:add_spec).with "spec", [error]
        spec.run(@reporter)
      end
      
      def test_should_add_itself_to_reporter_when_calling_run_docs
        spec = Specification.new("spec") {}
        @reporter.should_receive(:add_spec).with "spec"
        spec.run_docs(@reporter)
      end

      def test_should_verify_mocks_after_teardown
        spec = Specification.new("spec") do
          mock = mock("a mock")
          mock.should_receive(:poke)
        end
        @reporter.should_receive(:add_spec) do |spec_name, errors|
          spec_name.should.equal "spec"
          errors[0].message.should.match /expected poke once, but received it 0 times/
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
        @reporter.should_receive(:add_spec) do |spec, errors| 
          errors.length.should.equal 2
          errors[0].message.should.equal "in body"
          errors[1].message.should.equal "in teardown"
        end
        spec.run @reporter, nil, teardown
      end
      
      def teardown
        @reporter.__verify
      end
    end
  end
end