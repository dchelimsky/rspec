require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe ExampleDefinition, "#pending?" do
      it "returns false when a block is passed in" do
        runner = ExampleDefinition.new("My description") {}
        runner.should_not be_pending
      end

      it "returns true when a block is not passed in" do
        runner = ExampleDefinition.new("My description")
        runner.should be_pending
      end
    end
  end
end
