require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Extensions
    describe Main do
      before(:each) do
        @main = Class.new do; include Main; end
      end

      after(:each) do
        $rspec_story_steps = @original_rspec_story_steps
      end

      specify {@main.should respond_to(:describe)}
      specify {@main.should respond_to(:context)}

      it "should raise when no block is given to describe" do
        lambda { @main.describe "foo" }.should raise_error(ArgumentError)
      end

      it "should raise when no description is given to describe" do
        lambda { @main.describe do; end }.should raise_error(ArgumentError)
      end

      it "should run registered ExampleGroups" do
        example_group = @main.describe("The ExampleGroup") do end
        Spec::Runner.options.example_groups.should include(example_group)
      end

      it "should not run unregistered ExampleGroups" do
        example_group = @main.describe("The ExampleGroup") { unregister }
        Spec::Runner.options.example_groups.should_not include(example_group)
      end
      
      it "should create a shared ExampleGroup with share_examples_for" do
        group = @main.share_examples_for "all things" do end
        group.should be_an_instance_of(Spec::Example::SharedExampleGroup)
      end
      
      describe "#share_as" do
        before(:each) do
          $share_as_examples_example_module_number ||= 1
          $share_as_examples_example_module_number += 1
          @group_name = "Group#{$share_as_examples_example_module_number}"
        end

        it "should create a shared ExampleGroup" do
          group = @main.share_as @group_name do end
          group.should be_an_instance_of(Spec::Example::SharedExampleGroup)
        end
        
        it "should create a constant that points to a Module" do
          group = @main.share_as @group_name do end
          Object.const_get(@group_name).should equal(group)
        end
        
        it "should bark if you pass it something not-constantizable" do
          lambda do
            @group = @main.share_as "Non Constant" do end
          end.should raise_error(NameError, /The first argument to share_as must be a legal name for a constant/)
        end
        
      end
    end
  end
end