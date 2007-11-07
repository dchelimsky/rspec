require File.dirname(__FILE__) + '/../../spec_helper'

describe "the BehaviourFactory" do
  it "should return a ModelExample when given :behaviour_type => :model" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :behaviour_type => :model)
    behaviour_class.superclass.should == Spec::Rails::DSL::ModelExample
  end

  it "should return a ModelExample when given :spec_path => '/blah/spec/models/'" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '/blah/spec/models/blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::ModelExample
  end

  it "should return a ModelExample when given :spec_path => '\\blah\\spec\\models\\' (windows format)" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '\\blah\\spec\\models\\blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::ModelExample
  end

  it "should return a RailsExample when given :spec_path => '/blah/spec/foo/' (anything other than controllers, views and helpers)" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '/blah/spec/foo/blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::RailsExample
  end

  it "should return a RailsExample when given :spec_path => '\\blah\\spec\\foo\\' (windows format)  (anything other than controllers, views and helpers)" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '\\blah\\spec\\foo\\blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::RailsExample
  end

  it "should return a ViewExample when given :behaviour_type => :model" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :behaviour_type => :view)
    behaviour_class.superclass.should == Spec::Rails::DSL::ViewExample
  end

  it "should return a ViewExample when given :spec_path => '/blah/spec/views/'" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '/blah/spec/views/blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::ViewExample
  end

  it "should return a ModelExample when given :spec_path => '\\blah\\spec\\views\\' (windows format)" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '\\blah\\spec\\views\\blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::ViewExample
  end

  it "should return a HelperExample when given :behaviour_type => :helper" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :behaviour_type => :helper)
    behaviour_class.superclass.should == Spec::Rails::DSL::HelperExample
  end

  it "should return a HelperExample when given :spec_path => '/blah/spec/helpers/'" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '/blah/spec/helpers/blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::HelperExample
  end

  it "should return a ModelExample when given :spec_path => '\\blah\\spec\\helpers\\' (windows format)" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '\\blah\\spec\\helpers\\blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::HelperExample
  end

  it "should return a ControllerExample when given :behaviour_type => :controller" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :behaviour_type => :controller)
    behaviour_class.superclass.should == Spec::Rails::DSL::ControllerExample
  end

  it "should return a ControllerExample when given :spec_path => '/blah/spec/controllers/'" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '/blah/spec/controllers/blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::ControllerExample
  end

  it "should return a ModelExample when given :spec_path => '\\blah\\spec\\controllers\\' (windows format)" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '\\blah\\spec\\controllers\\blah.rb')
    behaviour_class.superclass.should == Spec::Rails::DSL::ControllerExample
  end

  it "should favor the :behaviour_type over the :spec_path" do
    behaviour_class = Spec::DSL::BehaviourFactory.create_behaviour_class("name", :spec_path => '/blah/spec/models/blah.rb', :behaviour_type => :controller)
    behaviour_class.superclass.should == Spec::Rails::DSL::ControllerExample
  end

end
