require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    context "ContextMatching" do

      setup do
        @formatter = Spec::Mocks::Mock.new("formatter")
        @behaviour = Behaviour.new("context") {}
      end

      specify "run all specs when spec is not specified" do
        @behaviour.specify("spec1") {}
        @behaviour.specify("spec2") {}
        @behaviour.retain_examples_matching!(["context"])
        @behaviour.number_of_examples.should == 2
      end

      specify "should only run specified examples when specified" do
        @behaviour.specify("spec1") {}
        @behaviour.specify("spec2") {}
        @behaviour.retain_examples_matching!(["context spec1"])
        @behaviour.number_of_examples.should == 1
      end
    end
  end
end