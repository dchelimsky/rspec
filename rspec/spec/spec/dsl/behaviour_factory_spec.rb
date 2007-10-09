require File.dirname(__FILE__) + '/../../spec_helper'

class BehaviourFactorySpec < Spec::DSL::Example
  describe Spec::DSL::BehaviourFactory, "#add_behaviour_class"

  class SomeBehaviourClass
  end

  before do
    Spec::DSL::BehaviourFactory.should_receive(:warn).
      with("add_behaviour_class is deprecated. Use add_example_class instead.")
    Spec::DSL::BehaviourFactory.add_behaviour_class(:some, SomeBehaviourClass)
  end

  after do
    Spec::DSL::BehaviourFactory::BEHAVIOURS.delete(:some)
  end

  it "should add behaviour to BEHAVIOURS repository" do
    Spec::DSL::BehaviourFactory::BEHAVIOURS[:some].should == SomeBehaviourClass
  end
end
