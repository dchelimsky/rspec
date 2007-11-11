require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe ExampleGroupFactory do
      it "should return a ModelExample when given :behaviour_type => :model" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :behaviour_type => :model)
        behaviour.superclass.should == Spec::Rails::DSL::ModelExample
      end

      it "should return a ModelExample when given :spec_path => '/blah/spec/models/'" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '/blah/spec/models/blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::ModelExample
      end

      it "should return a ModelExample when given :spec_path => '\\blah\\spec\\models\\' (windows format)" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '\\blah\\spec\\models\\blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::ModelExample
      end

      it "should return a RailsExample when given :spec_path => '/blah/spec/foo/' (anything other than controllers, views and helpers)" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '/blah/spec/foo/blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::RailsExample
      end

      it "should return a RailsExample when given :spec_path => '\\blah\\spec\\foo\\' (windows format)  (anything other than controllers, views and helpers)" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '\\blah\\spec\\foo\\blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::RailsExample
      end

      it "should return a ViewExample when given :behaviour_type => :model" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :behaviour_type => :view)
        behaviour.superclass.should == Spec::Rails::DSL::ViewExample
      end

      it "should return a ViewExample when given :spec_path => '/blah/spec/views/'" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '/blah/spec/views/blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::ViewExample
      end

      it "should return a ModelExample when given :spec_path => '\\blah\\spec\\views\\' (windows format)" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '\\blah\\spec\\views\\blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::ViewExample
      end

      it "should return a HelperExample when given :behaviour_type => :helper" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :behaviour_type => :helper)
        behaviour.superclass.should == Spec::Rails::DSL::HelperExample
      end

      it "should return a HelperExample when given :spec_path => '/blah/spec/helpers/'" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '/blah/spec/helpers/blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::HelperExample
      end

      it "should return a ModelExample when given :spec_path => '\\blah\\spec\\helpers\\' (windows format)" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '\\blah\\spec\\helpers\\blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::HelperExample
      end

      it "should return a ControllerExample when given :behaviour_type => :controller" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :behaviour_type => :controller)
        behaviour.superclass.should == Spec::Rails::DSL::ControllerExample
      end

      it "should return a ControllerExample when given :spec_path => '/blah/spec/controllers/'" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '/blah/spec/controllers/blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::ControllerExample
      end

      it "should return a ModelExample when given :spec_path => '\\blah\\spec\\controllers\\' (windows format)" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '\\blah\\spec\\controllers\\blah.rb')
        behaviour.superclass.should == Spec::Rails::DSL::ControllerExample
      end

      it "should favor the :behaviour_type over the :spec_path" do
        behaviour = Spec::DSL::ExampleGroupFactory.create_example_group("name", :spec_path => '/blah/spec/models/blah.rb', :behaviour_type => :controller)
        behaviour.superclass.should == Spec::Rails::DSL::ControllerExample
      end
    end
  end
end
