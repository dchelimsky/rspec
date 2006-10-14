require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Runner
context "Specification" do
    setup do
        @reporter = Spec::Mocks::Mock.new("reporter")
      
    end
    teardown do
        @reporter.__verify
      
    end
    specify "should add itself to reporter when calling run dry" do
      
        spec=Specification.new("spec") do
          
        end
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
      
        spec=Specification.new("spec") do
          
        end
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
        (not spec.matches_matcher?(SpecMatcher.new("context spec", "context"))).should_be(true)
      
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
            spec.should_equal("spec")
            location.should_equal("spec")
            error.message.should_equal("in body")
          
        end
        spec.run(@reporter, nil, teardown)
      
    end
    specify "should supply setup as spec name if failure in setup" do
        spec=Specification.new("spec") do
          
        end
        setup=lambda do
          raise("in setup")
        end
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished) do |name, error, location|
            name.should_equal("spec")
            error.message.should_equal("in setup")
            location.should_equal("setup")
          
        end
        spec.run(@reporter, setup)
      
    end
    specify "should supply teardown as failure location if failure in teardown" do
        spec=Specification.new("spec") do
          
        end
        teardown=lambda do
          raise("in teardown")
        end
        @reporter.should_receive(:spec_started).with("spec")
        @reporter.should_receive(:spec_finished) do |name, error, location|
            name.should_equal("spec")
            error.message.should_equal("in teardown")
            location.should_equal("teardown")
          
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
            spec_name.should_equal("spec")
            error.message.should_match(/expected :poke once, but received it 0 times/)
          
        end
        spec.run(@reporter)
      
    end
  
end
end
end