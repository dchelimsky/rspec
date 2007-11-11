require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe Example do
      it "should create an Example using the passed in block" do
        example_definition = Example.new "example" do "success" end
        example_definition.call.should == "success"
      end

      it "should create a block that raises ExamplePendingError when no block is passed in" do
        example_definition = Example.new "example"
        lambda {
          example_definition.call
        }.should raise_error(ExamplePendingError)
      end
    end
  end
end
