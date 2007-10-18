require File.dirname(__FILE__) + '/../../spec_helper'

class BehaviourFactorySpec < Spec::DSL::Example
  describe Spec::DSL::BehaviourFactory

  class SomeBehaviourClass
  end

  after do
    Spec::DSL::BehaviourFactory::BEHAVIOURS.delete(:some)
  end

  specify "#register_behaviour; adds behaviour to BEHAVIOURS repository" do
    Spec::DSL::BehaviourFactory.register_behaviour(:some, SomeBehaviourClass)
    Spec::DSL::BehaviourFactory::BEHAVIOURS[:some].should == SomeBehaviourClass
  end

  specify "#add_behaviour_class; add behaviour to BEHAVIOURS repository" do
    Spec::DSL::BehaviourFactory.should_receive(:warn).
      with("add_behaviour_class is deprecated. Use register_behaviour instead.")
    Spec::DSL::BehaviourFactory.add_behaviour_class(:some, SomeBehaviourClass)
    Spec::DSL::BehaviourFactory::BEHAVIOURS[:some].should == SomeBehaviourClass
  end

  specify "#register_behaviour; add behaviour to BEHAVIOURS repository" do
    Spec::DSL::BehaviourFactory.should_receive(:warn).
      with("add_example_class is deprecated. Use register_behaviour instead.")
    Spec::DSL::BehaviourFactory.add_example_class(:some, SomeBehaviourClass)
    Spec::DSL::BehaviourFactory::BEHAVIOURS[:some].should == SomeBehaviourClass
  end
end
