require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    class BehaviourFactorySpec < Spec::DSL::Example
      describe BehaviourFactory, "#register"

      class SomeBehaviourClass
      end

      after do
        BehaviourFactory::BEHAVIOURS.delete(:some)
      end

      specify "#register; adds behaviour to BEHAVIOURS repository" do
        BehaviourFactory.register(:some, SomeBehaviourClass)
        BehaviourFactory::BEHAVIOURS[:some].should == SomeBehaviourClass
      end

      specify "#add_behaviour_class; add behaviour to BEHAVIOURS repository" do
        BehaviourFactory.should_receive(:warn).
          with("add_behaviour_class is deprecated. Use register instead.")
        BehaviourFactory.add_behaviour_class(:some, SomeBehaviourClass)
        BehaviourFactory::BEHAVIOURS[:some].should == SomeBehaviourClass
      end

      specify "#register; add behaviour to BEHAVIOURS repository" do
        BehaviourFactory.should_receive(:warn).
          with("add_example_class is deprecated. Use register instead.")
        BehaviourFactory.add_example_class(:some, SomeBehaviourClass)
        BehaviourFactory::BEHAVIOURS[:some].should == SomeBehaviourClass
      end
    end

    describe BehaviourFactory, "#get" do
      before do
        @behaviour = Class.new(Example)
        BehaviourFactory.register(:foobar, @behaviour)
      end

      after do
        BehaviourFactory.unregister(:foobar)
      end

      it "when passed an id; returns the behaviour for the passed in id" do
        BehaviourFactory.get(:foobar).should == @behaviour
      end

      it "when passed in the actual behaviour; returns the behaviour" do
        BehaviourFactory.get(@behaviour).should == @behaviour
      end
    end    
  end
end
