require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe Example do
      it "should have a description and method_name" do
        example = Example.new "example", "my_method_name"
        example.description.should == "example"
        example.method_name.should == "my_method_name"
      end
    end
  end
end
