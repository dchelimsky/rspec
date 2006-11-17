require File.dirname(__FILE__) + '/spec_helper'

context "the ContextFactory" do
  setup do
    Spec::Rails::Context.handle_underscores_for_rspec!
  end
  
  specify "should return a ModelContext when given :context_type => :model" do
    Spec::Rails::ContextFactory.create("name", :context_type => :model) {
    }.should_be_an_instance_of Spec::Rails::ModelContext
  end
  
  specify "should return a ModelContext when given :spec_path => '/blah/spec/models/'" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '/blah/spec/models/blah.rb') {
    }.should_be_an_instance_of Spec::Rails::ModelContext
  end
  
  specify "should return a ModelContext when given :spec_path => '\blah\spec\models\' (windows format)" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '\blah\spec\models\blah.rb') {
    }.should_be_an_instance_of Spec::Rails::ModelContext
  end
  
  specify "should return a ViewContext when given :context_type => :model" do
    Spec::Rails::ContextFactory.create("name", :context_type => :view) {
    }.should_be_an_instance_of Spec::Rails::ViewContext
  end
  
  specify "should return a ViewContext when given :spec_path => '/blah/spec/views/'" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '/blah/spec/views/blah.rb') {
    }.should_be_an_instance_of Spec::Rails::ViewContext
  end
  
  specify "should return a ModelContext when given :spec_path => '\blah\spec\views\' (windows format)" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '\blah\spec\views\blah.rb') {
    }.should_be_an_instance_of Spec::Rails::ViewContext
  end
  
  specify "should return a HelperContext when given :context_type => :helper" do
    Spec::Rails::ContextFactory.create("name", :context_type => :helper) {
    }.should_be_an_instance_of Spec::Rails::HelperContext
  end
  
  specify "should return a HelperContext when given :spec_path => '/blah/spec/helpers/'" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '/blah/spec/helpers/blah.rb') {
    }.should_be_an_instance_of Spec::Rails::HelperContext
  end
  
  specify "should return a ModelContext when given :spec_path => '\blah\spec\helpers\' (windows format)" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '\blah\spec\helpers\blah.rb') {
    }.should_be_an_instance_of Spec::Rails::HelperContext
  end
  
  specify "should return a ControllerContext when given :context_type => :controller" do
    Spec::Rails::ContextFactory.create("name", :context_type => :controller) {
    }.should_be_an_instance_of Spec::Rails::ControllerContext
  end
  
  specify "should return a ControllerContext when given :spec_path => '/blah/spec/controllers/'" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '/blah/spec/controllers/blah.rb') {
    }.should_be_an_instance_of Spec::Rails::ControllerContext
  end
  
  specify "should return a ModelContext when given :spec_path => '\blah\spec\controllers\' (windows format)" do
    Spec::Rails::ContextFactory.create("name", :spec_path => '\blah\spec\controllers\blah.rb') {
    }.should_be_an_instance_of Spec::Rails::ControllerContext
  end
end
