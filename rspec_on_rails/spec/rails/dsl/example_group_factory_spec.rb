require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe ExampleGroupFactory do
      it "should return a ModelExampleGroup when given :behaviour_type => :model" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :behaviour_type => :model
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ModelExampleGroup
      end

      it "should return a ModelExampleGroup when given :spec_path => '/blah/spec/models/'" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/models/blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ModelExampleGroup
      end

      it "should return a ModelExampleGroup when given :spec_path => '\\blah\\spec\\models\\' (windows format)" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '\\blah\\spec\\models\\blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ModelExampleGroup
      end

      it "should return a RailsExampleGroup when given :spec_path => '/blah/spec/foo/' (anything other than controllers, views and helpers)" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/foo/blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::RailsExampleGroup
      end

      it "should return a RailsExampleGroup when given :spec_path => '\\blah\\spec\\foo\\' (windows format)  (anything other than controllers, views and helpers)" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '\\blah\\spec\\foo\\blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::RailsExampleGroup
      end

      it "should return a ViewExampleGroup when given :behaviour_type => :model" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :behaviour_type => :view
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ViewExampleGroup
      end

      it "should return a ViewExampleGroup when given :spec_path => '/blah/spec/views/'" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/views/blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ViewExampleGroup
      end

      it "should return a ModelExampleGroup when given :spec_path => '\\blah\\spec\\views\\' (windows format)" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '\\blah\\spec\\views\\blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ViewExampleGroup
      end

      it "should return a HelperExampleGroup when given :behaviour_type => :helper" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :behaviour_type => :helper
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::HelperExampleGroup
      end

      it "should return a HelperExampleGroup when given :spec_path => '/blah/spec/helpers/'" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/helpers/blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::HelperExampleGroup
      end

      it "should return a ModelExampleGroup when given :spec_path => '\\blah\\spec\\helpers\\' (windows format)" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '\\blah\\spec\\helpers\\blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::HelperExampleGroup
      end

      it "should return a ControllerExampleGroup when given :behaviour_type => :controller" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :behaviour_type => :controller
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ControllerExampleGroup
      end

      it "should return a ControllerExampleGroup when given :spec_path => '/blah/spec/controllers/'" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/controllers/blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ControllerExampleGroup
      end

      it "should return a ModelExampleGroup when given :spec_path => '\\blah\\spec\\controllers\\' (windows format)" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '\\blah\\spec\\controllers\\blah.rb'
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ControllerExampleGroup
      end

      it "should favor the :behaviour_type over the :spec_path" do
        behaviour = Spec::Example::ExampleGroupFactory.create_example_group(
          "name", :spec_path => '/blah/spec/models/blah.rb', :behaviour_type => :controller
        ) {}
        behaviour.superclass.should == Spec::Rails::Example::ControllerExampleGroup
      end
    end
  end
end
