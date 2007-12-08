require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe ExampleGroupDescription, "constructed with a single String" do
      before(:each) do
        @description = ExampleGroupDescription.new("abc")
      end
      
      it "should provide that string as its name" do
        @description.text.should == "abc"
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
    
    describe ExampleGroupDescription, "constructed with a Type" do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup)
      end

      it "should provide a String representation of that type (fully qualified) as its name" do
        @description.text.should == "Spec::Example::ExampleGroup"
      end
      
      it "should provide that type (fully qualified) as its type" do
        @description.described_type.should == Spec::Example::ExampleGroup
      end
    end
    
    describe ExampleGroupDescription, "constructed with a String and a Type" do
      before(:each) do
        @description = ExampleGroupDescription.new("behaving", ExampleGroup)
      end
      
      it "should include the type and second String in its name" do
        @description.text.should == "behaving Spec::Example::ExampleGroup"
      end
      
      it "should provide that type (fully qualified) as its type" do
        @description.described_type.should == Spec::Example::ExampleGroup
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String not starting with a space" do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup, "behaving")
      end

      it "should include the type and second String with a space in its name" do
        @description.text.should == "Spec::Example::ExampleGroup behaving"
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String starting with a ." do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup, ".behaving")
      end

      it "should include the type and second String with a space in its name" do
        @description.text.should == "Spec::Example::ExampleGroup.behaving"
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String containing a ." do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup, "calling a.b")
      end

      it "should include the type and second String with a space in its name" do
        @description.text.should == "Spec::Example::ExampleGroup calling a.b"
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String starting with a #" do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup, "#behaving")
      end

      it "should include the type and second String with a space in its name" do
        @description.text.should == "Spec::Example::ExampleGroup#behaving"
      end
    end

    describe ExampleGroupDescription, "constructed with a Type and a String containing a #" do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup, "is #1")
      end

      it "should include the type and second String with a space in its name" do
        @description.text.should == "Spec::Example::ExampleGroup is #1"
      end
    end

    describe ExampleGroupDescription, "constructed with String, Type, String" do
      before(:each) do
        @description = ExampleGroupDescription.new("A", Hash, "with one entry")
      end

      it "should include create a description with all arguments" do
        @description.text.should == "A Hash with one entry"
      end
    end
    
    describe ExampleGroupDescription, "constructed with ExampleGroupDescription, String" do
      it "should get the described type from the parent" do
        super_description = ExampleGroupDescription.new(Hash)
        nested_description = ExampleGroupDescription.new(super_description, "with one entry")
        nested_description.text.should == "Hash with one entry"
        nested_description.described_type.should == Hash
      end
    end
    
    describe ExampleGroupDescription, "constructed with options" do
      before(:each) do
        @description = ExampleGroupDescription.new(ExampleGroup, :a => "b", :spec_path => "blah")
      end

      it "should expose its options" do
        @description[:a].should == "b"
      end
      
      it "should wrap spec path using File.expand_path" do
        @description[:spec_path].should == File.expand_path("blah")
      end
    end

    describe ExampleGroupDescription, "from a parent ExampleGroupDescription with described type" do
      before do
        @parent = ExampleGroupDescription.new(Array)
      end
      
      it "should take the type from itself when it has a type" do
        child = ExampleGroupDescription.new(@parent, Hash)
        child.described_type.should == Hash
      end

      it "should take the type from parent when it doesn't have a type" do
        child = ExampleGroupDescription.new(@parent)
        child.described_type.should == Array
      end
    end
    
    describe ExampleGroupDescription, "from a nested ExampleGroupDescription without described type" do
      before do
        @parent = ExampleGroupDescription.new("Not a type")
      end

      it "should take the type from itself when it has a type" do
        child = ExampleGroupDescription.new(@parent, Hash)
        child.described_type.should == Hash
      end

      it "should have no type when it doesn't have a type" do
        child = ExampleGroupDescription.new(@parent)
        child.described_type.should == nil
      end
    end
  end
end
