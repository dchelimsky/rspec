require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Extensions
    describe Main do
      it_should_behave_like "sandboxed rspec_options"
      before(:each) do
        @main = Class.new do; include Main; end
      end

      after(:each) do
        $rspec_story_steps = @original_rspec_story_steps
      end

      it "should create an Options object" do
        @main.send(:rspec_options).should be_instance_of(Spec::Runner::Options)
        @main.send(:rspec_options).should === $rspec_options
      end
  
      specify {@main.should respond_to(:describe)}
      specify {@main.should respond_to(:context)}

      it "should raise when no block given to describe" do
        lambda { @main.describe "foo" }.should raise_error(ArgumentError)
      end

      it "should raise when no description given to describe" do
        lambda { @main.describe do; end }.should raise_error(ArgumentError)
      end

      it "should registered ExampleGroups by default" do
        example_group = @main.describe("The ExampleGroup") do end
        rspec_options.example_groups.should include(example_group)
      end

      it "should not run unregistered ExampleGroups" do
        example_group = @main.describe("The ExampleGroup") do
          unregister
        end

        rspec_options.example_groups.should_not include(example_group)
      end
      
      it "should create a shared ExampleGroup with shared_examples_for" do
        group = @main.shared_examples_for "all things" do end
        group.should be_an_instance_of(Spec::Example::SharedExampleGroup)
      end
    end
  end
end