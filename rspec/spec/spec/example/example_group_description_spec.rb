require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe ExampleGroupDescription do
      attr_reader :example_group
      before do
        @example_group = Class.new(ExampleGroup)
      end
      
      describe ExampleGroupDescription, "#initialize(ExampleGroup, String)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, "abc")
        end

        specify "#text should return the String passed into #initialize" do
          @description.text.should == "abc"
        end

        specify "#text_parts should return an Array containing #text" do
          @description.text_parts.should == ["abc"]
        end

        specify "#described_type should provide nil as its type" do
          @description.described_type.should be_nil
        end

        specify "#== should compare against the #text" do
          @description.should == "abc"
        end

        specify "#== should compare against the #text of the other ExampleGroupDescription when passed ExampleGroupDescription" do
          @description.should == ExampleGroupDescription.new(example_group, "abc")
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, Type)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, ExampleGroup)
        end

        specify "#text should return a String representation of that type (fully qualified) as its name" do
          @description.text.should == "Spec::Example::ExampleGroup"
        end

        specify "#described_type should return the passed in type" do
          @description.described_type.should == Spec::Example::ExampleGroup
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, String, Type)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, "behaving", ExampleGroup)
        end

        specify "#text should return String then space then Type" do
          @description.text.should == "behaving Spec::Example::ExampleGroup"
        end

        specify "#described_type should return the passed in type" do
          @description.described_type.should == Spec::Example::ExampleGroup
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, Type, String not starting with a space)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, ExampleGroup, "behaving")
        end

        specify "#text should return the Type then space then String" do
          @description.text.should == "Spec::Example::ExampleGroup behaving"
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, Type, String starting with .)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, ExampleGroup, ".behaving")
        end

        specify "#text should return the Type then String" do
          @description.text.should == "Spec::Example::ExampleGroup.behaving"
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, Type, String containing .)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, ExampleGroup, "calling a.b")
        end

        specify "#text should return the Type then space then String" do
          @description.text.should == "Spec::Example::ExampleGroup calling a.b"
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, Type, String starting with #)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, ExampleGroup, "#behaving")
        end

        specify "should return the Type then String" do
          @description.text.should == "Spec::Example::ExampleGroup#behaving"
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, Type, String containing #)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, ExampleGroup, "is #1")
        end

        specify "#text should return the Type then space then String" do
          @description.text.should == "Spec::Example::ExampleGroup is #1"
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, String, Type, String)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, "A", Hash, "with one entry")
        end

        specify "#text should return the first String then space then Type then second String" do
          @description.text.should == "A Hash with one entry"
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, ExampleGroupDescription, String)" do
        attr_reader :super_description, :nested_description
        before do
          @super_description = ExampleGroupDescription.new(example_group, Hash)
          @nested_description = ExampleGroupDescription.new(example_group, super_description, "with one entry")
        end

        specify "#described_type should return the #described_type from the parent" do
          nested_description.described_type.should == Hash
        end

        specify "#text should return its parent's #type then its String" do
          nested_description.text.should == "Hash with one entry"
        end
      end

      describe ExampleGroupDescription, "#initialize(ExampleGroup, Hash representing options)" do
        before(:each) do
          @description = ExampleGroupDescription.new(example_group, ExampleGroup, :a => "b", :spec_path => "blah")
        end

        it "#spec_path should expand the passed in :spec_path option passed into the constructor" do
          @description.spec_path.should == File.expand_path("blah")
        end
      end

      describe ExampleGroupDescription, "from a parent ExampleGroupDescription with described type" do
        before do
          @parent = ExampleGroupDescription.new(example_group, Array)
        end

        it "#described_type should return its own type when #initialize passed a type" do
          child = ExampleGroupDescription.new(example_group, @parent, Hash)
          child.described_type.should == Hash
        end

        it "#described_type should return its parent type when #initialize not passed a type" do
          child = ExampleGroupDescription.new(example_group, @parent)
          child.described_type.should == Array
        end
      end

      describe ExampleGroupDescription, "from a nested ExampleGroupDescription without described type" do
        before do
          @parent = ExampleGroupDescription.new(example_group, "Not a type")
        end

        it "#described_type should return its type when #initialize passed a type" do
          child = ExampleGroupDescription.new(example_group, @parent, Hash)
          child.described_type.should == Hash
        end

        it "#described_type should return its parent's type when #initialize not passed a type" do
          child = ExampleGroupDescription.new(example_group, @parent)
          child.described_type.should == nil
        end
      end
    end
  end
end
