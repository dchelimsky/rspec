require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe Example do
      before(:each) do
        @example = Example.new "example" do
          foo
        end
      end
      
      it "should tell you its docstring" do
        @example.description.should == "example"
      end

      it "should execute its block in the context provided" do
        context = Class.new do
          def foo
            "foo"
          end
        end.new
        @example.run_in(context).should == "foo"
      end
    end
  end
end
