require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe Main do
      before(:each) do
        @main = Class.new do; include Main; end
      end

      [:describe, :context].each do |method|
        describe "##{method}" do
          it "should delegate to Spec::Example::ExampleGroupFactory.create_example_group" do
            block = lambda {}
            Spec::Example::ExampleGroupFactory.should_receive(:create_example_group).with(
              "The ExampleGroup", &block
            )
            example_group = @main.__send__ method, "The ExampleGroup", &block
          end
        end
      end
    
      describe "#share_examples_for" do
        it "should create a shared ExampleGroup" do
          group = @main.share_examples_for "all things" do end
          group.should be_an_instance_of(Spec::Example::SharedExampleGroup)
        end
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
  