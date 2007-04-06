require File.dirname(__FILE__) + '/../../spec_helper'

context "the BehaviourFactory" do
  specify "should return a ModelBehaviour when given :context_type => :model" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :context_type => :model) {
    }.should be_an_instance_of(Spec::Rails::DSL::ModelBehaviour)
  end
  
  specify "should return a ModelBehaviour when given :spec_path => '/blah/spec/models/'" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '/blah/spec/models/blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::ModelBehaviour)
  end
  
  specify "should return a ModelBehaviour when given :spec_path => '\blah\spec\models\' (windows format)" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '\blah\spec\models\blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::ModelBehaviour)
  end
  
  specify "should return a ViewBehaviour when given :context_type => :model" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :context_type => :view) {
    }.should be_an_instance_of(Spec::Rails::DSL::ViewBehaviour)
  end
  
  specify "should return a ViewBehaviour when given :spec_path => '/blah/spec/views/'" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '/blah/spec/views/blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::ViewBehaviour)
  end
  
  specify "should return a ModelBehaviour when given :spec_path => '\blah\spec\views\' (windows format)" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '\blah\spec\views\blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::ViewBehaviour)
  end
  
  specify "should return a HelperBehaviour when given :context_type => :helper" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :context_type => :helper) {
    }.should be_an_instance_of(Spec::Rails::DSL::HelperBehaviour)
  end
  
  specify "should return a HelperBehaviour when given :spec_path => '/blah/spec/helpers/'" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '/blah/spec/helpers/blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::HelperBehaviour)
  end
  
  specify "should return a ModelBehaviour when given :spec_path => '\blah\spec\helpers\' (windows format)" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '\blah\spec\helpers\blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::HelperBehaviour)
  end
  
  specify "should return a ControllerBehaviour when given :context_type => :controller" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :context_type => :controller) {
    }.should be_an_instance_of(Spec::Rails::DSL::ControllerBehaviour)
  end
  
  specify "should return a ControllerBehaviour when given :spec_path => '/blah/spec/controllers/'" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '/blah/spec/controllers/blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::ControllerBehaviour)
  end
  
  specify "should return a ModelBehaviour when given :spec_path => '\blah\spec\controllers\' (windows format)" do
    Spec::Rails::Runner::BehaviourFactory.create("name", :spec_path => '\blah\spec\controllers\blah.rb') {
    }.should be_an_instance_of(Spec::Rails::DSL::ControllerBehaviour)
  end
end
