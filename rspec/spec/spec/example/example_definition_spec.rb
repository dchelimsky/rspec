require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe Example do
      it "should create an Example using the passed in block" do
        example = Example.new "example" do "success" end
        example.example_block.call.should == "success"
      end

      it "should create a block that raises ExamplePendingError when no block is passed in" do
        example = Example.new "example"
        lambda {
          example.example_block.call
        }.should raise_error(ExamplePendingError)
      end
    end
  end
end
