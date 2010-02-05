require 'spec_helper'

module Spec
  module Mocks
    describe "stubbing a base class class method" do
      before do
        @base_class     = Class.new
        @concrete_class = Class.new(@base_class)

        @base_class.stub!(:find).and_return "stubbed_value"
      end

      it "should return the value for the stub on the base class" do
        @base_class.find.should == "stubbed_value"
      end

      it "should return the value for the descendent class" do
        @concrete_class.find.should == "stubbed_value"
      end
    end
  end
end
