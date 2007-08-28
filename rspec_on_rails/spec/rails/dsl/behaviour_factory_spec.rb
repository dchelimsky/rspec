require File.dirname(__FILE__) + '/../../spec_helper'

describe "the BehaviourFactory" do
  it "should return a ModelBehaviour when given :behaviour_type => :model" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :behaviour_type => :model)
    behaviour.superclass.should == Spec::Rails::DSL::ModelBehaviour
  end

  it "should return a ModelBehaviour when given :spec_path => '/blah/spec/models/'" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '/blah/spec/models/blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::ModelBehaviour
  end

  it "should return a ModelBehaviour when given :spec_path => '\\blah\\spec\\models\\' (windows format)" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '\\blah\\spec\\models\\blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::ModelBehaviour
  end

  it "should return a ViewBehaviour when given :behaviour_type => :model" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :behaviour_type => :view)
    behaviour.superclass.should == Spec::Rails::DSL::ViewBehaviour
  end

  it "should return a ViewBehaviour when given :spec_path => '/blah/spec/views/'" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '/blah/spec/views/blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::ViewBehaviour
  end

  it "should return a ModelBehaviour when given :spec_path => '\\blah\\spec\\views\\' (windows format)" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '\\blah\\spec\\views\\blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::ViewBehaviour
  end

  it "should return a HelperBehaviour when given :behaviour_type => :helper" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :behaviour_type => :helper)
    behaviour.superclass.should == Spec::Rails::DSL::HelperBehaviour
  end

  it "should return a HelperBehaviour when given :spec_path => '/blah/spec/helpers/'" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '/blah/spec/helpers/blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::HelperBehaviour
  end

  it "should return a ModelBehaviour when given :spec_path => '\\blah\\spec\\helpers\\' (windows format)" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '\\blah\\spec\\helpers\\blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::HelperBehaviour
  end

  it "should return a ControllerBehaviour when given :behaviour_type => :controller" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :behaviour_type => :controller)
    behaviour.superclass.should == Spec::Rails::DSL::ControllerBehaviour
  end

  it "should return a ControllerBehaviour when given :spec_path => '/blah/spec/controllers/'" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '/blah/spec/controllers/blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::ControllerBehaviour
  end

  it "should return a ModelBehaviour when given :spec_path => '\\blah\\spec\\controllers\\' (windows format)" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '\\blah\\spec\\controllers\\blah.rb')
    behaviour.superclass.should == Spec::Rails::DSL::ControllerBehaviour
  end

  it "should favor the :behaviour_type over the :spec_path" do
    behaviour = Spec::DSL::BehaviourFactory.create("name", :spec_path => '/blah/spec/models/blah.rb', :behaviour_type => :controller)
    behaviour.superclass.should == Spec::Rails::DSL::ControllerBehaviour
  end

  it "should create a Spec::DSL::Behaviour if :shared => true" do
    Spec::DSL::BehaviourFactory.create("name", :spec_path => '/blah/spec/models/blah.rb', :behaviour_type => :controller, :shared => true) {
    }.should be_an_instance_of(Spec::DSL::SharedBehaviour)
  end
end
