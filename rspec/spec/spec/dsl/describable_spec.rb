require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe Describable, " constructed with a single String" do setup {@describable = Describable.new("abc")}
      it "should provide that string as its name" do
        @describable.description.should == "abc"
      end
      it "should provide nil as its type" do
        @describable.described_type.should be_nil
      end
      it "should respond to []" do
        @describable[:key].should be_nil
      end
      it "should respond to []=" do
        @describable[:key] = :value
        @describable[:key].should == :value
      end
    end
    
    describe Describable, " constructed with a Type" do setup {@describable = Describable.new(Behaviour)}
      it "should provide a String representation of that type (fully qualified) as its name" do
        @describable.description.should == "Spec::DSL::Behaviour"
      end
      it "should provide that type (fully qualified) as its type" do
        @describable.described_type.should == Spec::DSL::Behaviour
      end
    end
    
    describe Describable, " constructed with a Type and a String" do setup {@describable = Describable.new(Behaviour, " behaving")}
      it "should include the type and second String in its name" do
        @describable.description.should == "Spec::DSL::Behaviour behaving"
      end
      it "should provide that type (fully qualified) as its type" do
        @describable.described_type.should == Spec::DSL::Behaviour
      end
    end

    describe Describable, " constructed with options" do setup {@describable = Describable.new(Behaviour, :a => "b")}
      it "should provide its options" do
        @describable[:a].should == "b"
      end
    end
  end
end