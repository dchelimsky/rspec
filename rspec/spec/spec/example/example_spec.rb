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

    describe Example, "#description" do
      it "should default to NO NAME when not passed anything" do
        example = Example.new
        example.description.should == "NO NAME"
      end

      it "should default to NO NAME description (Because of --dry-run) when passed nil" do
        example = Example.new(nil)
        example.description.should == "NO NAME"
      end

      it "should allow description to be overridden" do
        example = Example.new("Test description")
        example.description.should == "Test description"
      end
    end
  end
end
