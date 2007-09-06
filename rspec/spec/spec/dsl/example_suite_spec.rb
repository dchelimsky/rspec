require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe ExampleSuite, "#size" do
      it "returns the number of examples in the behaviour" do
        behaviour = Class.new(Example) do
          it("does something") {}
          it("does something else") {}
        end
        suite = behaviour.suite
        suite.size.should == 2
      end
    end
  end
end
