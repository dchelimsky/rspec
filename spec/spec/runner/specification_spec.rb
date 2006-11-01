require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    context "Specification" do
      setup do
        @reporter = mock("reporter")
      end

      specify "should add itself to reporter when calling run dry" do
        spec=Specification.new("spec") {}
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished).with("spec")
        spec.run(@reporter, nil, nil, true)
      end

      specify "should add itself to reporter when fails" do
        error=RuntimeError.new
        spec=Specification.new("spec") do
          raise(error)
        end
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished).with("spec", error, "spec")
        spec.run(@reporter)
      end

      specify "should add itself to reporter when passes" do
        spec=Specification.new("spec") {}
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished).with("spec", nil, nil)
        spec.run(@reporter)
      end

      specify "should match if name matches end of input" do
        spec=Specification.new("spec")
        spec.matches_matcher?(SpecMatcher.new("context spec", "context")).should_be(true)
      end

      specify "should match if name matches entire input" do
        spec=Specification.new("spec")
        spec.matches_matcher?(SpecMatcher.new("spec", "context")).should_be(true)
      end

      specify "should not match if name does not match" do
        spec=Specification.new("otherspec")
        spec.matches_matcher?(SpecMatcher.new("context spec", "context")).should_be(false)
      end

      specify "should run spec in scope of execution context" do
        spec=Specification.new("should pass") do
          self.should_not_be_an_instance_of(Specification)
          self.should_be_an_instance_of(ExecutionContext)
        end
        @reporter.should_receive(:spec_started).with("should pass")
        @reporter.should_receive(:spec_finished).with("should pass", nil, nil)
        spec.run(@reporter)
        @reporter.__verify
      end

      specify "should run teardown even when main block fails" do
        spec=Specification.new("spec") do
          raise("in body")
        end
        teardown=lambda do
          raise("in teardown")
        end
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished) do |spec, error, location|
          spec.should_eql("spec")
          location.should_eql("spec")
          error.message.should_eql("in body")
        end
        spec.run(@reporter, nil, teardown)
      end

      specify "should supply setup as spec name if failure in setup" do
        spec=Specification.new("spec") {}
        setup=lambda { raise("in setup") }
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished) do |name, error, location|
          name.should_eql("spec")
          error.message.should_eql("in setup")
          location.should_eql("setup")
        end
        spec.run(@reporter, setup)
      end

      specify "should supply teardown as failure location if failure in teardown" do
        spec = Specification.new("spec") {}
        teardown = lambda { raise("in teardown") }
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished) do |name, error, location|
          name.should_eql("spec")
          error.message.should_eql("in teardown")
          location.should_eql("teardown")
        end
        spec.run(@reporter, nil, teardown)
      end

      specify "should verify mocks after teardown" do
        spec=Specification.new("spec") do
          mock=mock("a mock")
          mock.should_receive(:poke)
        end
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished) do |spec_name, error|
          spec_name.should_eql("spec")
          error.message.should_match(/expected :poke once, but received it 0 times/)
        end
        spec.run(@reporter)
      end
      
      specify "should accept an options hash following the spec name" do
        spec = Specification.new("name", :key => 'value')
      end
      
    end
  end
end
