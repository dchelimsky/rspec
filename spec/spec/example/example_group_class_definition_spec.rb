require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    class ExampleGroupSubclass < ExampleGroup
      class << self
        attr_accessor :examples_ran
      end

      @@class_variable = :class_variable
      CONSTANT = :constant

      before(:each) do
        @instance_variable = :instance_variable
      end
      
      after(:all) do
        self.class.examples_ran = true
      end

      def a_method
        22
      end

      it "can access instance variables defined before(:each)" do
        @instance_variable.should == :instance_variable
      end

      it "can access class variables" do
        @@class_variable.should == :class_variable
      end

      it "can access constants" do
        CONSTANT.should == :constant
      end

      it "can access methods defined in the Example Group" do
        a_method.should == 22
      end
      
    end

    describe ExampleGroupSubclass do
      it "should run" do
        ExampleGroupSubclass.examples_ran.should be_true
      end
    end
  end
end