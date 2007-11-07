require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    # This behaviour deliberately uses the class syntax. Keep it that way!
    class BehaviourFactorySpec < Spec::DSL::Example
      describe BehaviourFactory, "with :foobar registered as custom type"

      before do
        @behaviour = Class.new(Example)
        BehaviourFactory.register(:foobar, @behaviour)
      end

      after do
        BehaviourFactory.reset!
      end

      it "should #get the default behaviour type when passed nil" do
        BehaviourFactory.get(nil).should == Example
      end

      it "should #get custom type for :foobar" do
        BehaviourFactory.get(:foobar).should == @behaviour
      end

      it "should #get the actual type when that is passed in" do
        BehaviourFactory.get(@behaviour).should == @behaviour
      end

      it "should #get nil for unregistered non-nil values" do
        BehaviourFactory.get(:does_not_exist).should be_nil
      end

      it "should raise error for #get! with unknown key" do
        proc do
          BehaviourFactory.get!(:does_not_exist)
        end.should raise_error
      end
    end    
  end
end
