require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe Example do
      it "should have a description and implementation" do
        implementation_called = false
        example = Example.new "example" do
          implementation_called = true
        end
        example.description.should == "example"
        example.implementation.call
        implementation_called.should be_true
      end
    end
  end
end
