require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe ExampleGroupProxy do
      before(:each) do
        @group = stub("example group").as_null_object
      end
      
      attr_reader :group
      def proxy
        @proxy ||= ExampleGroupProxy.new(@group)
      end
      
      describe "#description" do
        it "provides the example group's description" do
          group.stub!(:description => "the description")
          proxy.description.should == "the description"
        end
      end

      describe "#nested_descriptions" do
        it "provides the example group's nested_descriptions" do
          group.stub!(:nested_descriptions => ["the description"])
          proxy.nested_descriptions.should == ["the description"]
        end
      end

      describe "#filtered_description" do
        it "builds the description from the group's nested_descriptions" do
          group.stub!(:nested_descriptions => ["ignore","the","description"])
          proxy.filtered_description(/ignore/).should == "the description"
        end
        it "filters out description parts that match the supplied regexp" do
          group.stub!(:nested_descriptions => ["ignore this one","the","description"])
          proxy.filtered_description(/ignore/).should == "the description"
        end
      end
      
      describe "#examples" do
        it "provides a collection of example group proxies" do
          group.stub!(:example_proxies => ["array","of","proxies"])
          proxy.examples.should == ["array","of","proxies"]
        end
      end
      
      describe "#backtrace (deprecated - use #location)" do
        it "provides the location of the declaration of this group" do
          group.stub!(:backtrace => "path/to/location:37")
          proxy.backtrace.should == "path/to/location:37"
        end
      end
      
      describe "#location" do
        it "provides the location of the declaration of this group" do
          group.stub!(:location => "path/to/location:37")
          proxy.location.should  == "path/to/location:37"
        end
      end
      
    end
  end
end
