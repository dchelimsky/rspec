require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
module Runner
context "ContextMatching" do
    setup do
        @formatter = Spec::Mocks::Mock.new("formatter")
        @context = Context.new("context") {}
        @matcher = Spec::Mocks::Mock.new("matcher")
      
    end
    specify "run all specs when spec is not specified" do
        @context.specify("spec1") {}
        @context.specify("spec2") {}
        @context.run_single_spec("context")
        @context.number_of_specs.should equal(2)
      
    end
    specify "should only run specified specs when specified" do
        @context.specify("spec1") {}
        @context.specify("spec2") {}
        @context.run_single_spec("context spec1")
        @context.number_of_specs.should equal(1)
      
    end
    specify "should use spec matcher" do
        @matcher.should_receive(:matches?).with("submitted spec")
        @context.specify("submitted spec") {}
        (not @context.matches?("context with spec", @matcher)).should_be(true)
      
    end
  
end
end
end