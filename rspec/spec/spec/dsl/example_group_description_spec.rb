require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe ExampleGroupDescription, " constructed with a single String" do
      before(:each) {@description = ExampleGroupDescription.new("abc")}
      
      it "should provide that string as its name" do
        @description.description.should == "abc"
      end
      it "should provide nil as its type" do
        @description.described_type.should be_nil
      end
      it "should respond to []" do
        @description[:key].should be_nil
      end
      it "should respond to []=" do
        @description[:key] = :value
        @description[:key].should == :value
      end
      it "should return for == when value matches description" do
        @description.should == "abc"
      end
      it "should return for == when value is other description that matches description" do
        @description.should == ExampleGroupDescription.new("abc")
      end
    end
    
    describe ExampleGroupDescription, " constructed with a Type" do
      before(:each) {@description = ExampleGroupDescription.new(ExampleGroup)}

      it "should provide a String representation of that type (fully qualified) as its name" do
        @description.description.should == "Spec::DSL::ExampleGroup"
      end
      it "should provide that type (fully qualified) as its type" do
        @description.described_type.should == Spec::DSL::ExampleGroup
      end
    end
    
    describe ExampleGroupDescription, " constructed with a Type and a String" do
      before(:each) {@description = ExampleGroupDescription.new(ExampleGroup, " behaving")}
      
      it "should include the type and second String in its name" do
        @description.description.should == "Spec::DSL::ExampleGroup behaving"
      end
      it "should provide that type (fully qualified) as its type" do
        @description.described_type.should == Spec::DSL::ExampleGroup
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String not starting with a space" do
      before(:each) {@description = ExampleGroupDescription.new(ExampleGroup, "behaving")}

      it "should include the type and second String with a space in its name" do
        @description.description.should == "Spec::DSL::ExampleGroup behaving"
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String starting with a ." do
      before(:each) {@description = ExampleGroupDescription.new(ExampleGroup, ".behaving")}

      it "should include the type and second String with a space in its name" do
        @description.description.should == "Spec::DSL::ExampleGroup.behaving"
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String starting with a #" do
      before(:each) {@description = ExampleGroupDescription.new(ExampleGroup, "#behaving")}

      it "should include the type and second String with a space in its name" do
        @description.description.should == "Spec::DSL::ExampleGroup#behaving"
      end
    end

    describe ExampleGroupDescription, "constructed with String, Type, String" do
      before(:each) {@description = ExampleGroupDescription.new("A", Hash, "with one entry")}

      it "should include create a description with all arguments" do
        @description.description.should == "A Hash with one entry"
      end
    end
    
    describe ExampleGroupDescription, " constructed with options" do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup, :a => "b", :spec_path => "blah")
      end

      it "should provide its options" do
        @description[:a].should == "b"
      end
      
      it "should wrap spec path using File.expand_path" do
        @description[:spec_path].should == File.expand_path("blah")
      end
    end
  end
end
