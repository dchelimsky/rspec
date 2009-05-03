require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    describe "stub implementation" do
      context "with no args" do
        it "execs the block when called" do
          obj = stub()
          obj.stub(:foo) { :bar }
          obj.foo.should == :bar
        end
      end
    end
  end
end