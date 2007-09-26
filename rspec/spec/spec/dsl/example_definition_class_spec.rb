require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe ExampleDefinition, " class" do
      before do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @reporter = ::Spec::Runner::Reporter.new(@options)
        @example_definition_class = ExampleDefinition.dup
        @behaviour = Class.new(Example).describe("My Behaviour")
      end
      
      it "should report errors in example" do
        error = Exception.new
        example_definition = @example_definition_class.new("example") {raise(error)}
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished).with(equal(example), error, "example", false)
        proxy.run
      end
    end
  end
end
