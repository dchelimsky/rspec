require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe "ExampleGroupMethods" do
      before do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @options.formatters << mock("formatter", :null_object => true)
        @options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
        @reporter = FakeReporter.new(@options)
        @options.reporter = @reporter

        ExampleGroupMethods.before_all_parts.should == []
        ExampleGroupMethods.before_each_parts.should == []
#        ExampleGroupMethods.example_parts.should == []
        ExampleGroupMethods.after_each_parts.should == []
        ExampleGroupMethods.after_all_parts.should == []
        def ExampleGroupMethods.count
          @count ||= 0
          @count = @count + 1
          @count
        end
      end

      after do
        ExampleGroupMethods.instance_variable_set("@before_all_parts", [])
        ExampleGroupMethods.instance_variable_set("@before_each_parts", [])
#        ExampleGroupMethods.instance_variable_set("@example_parts", [])
        ExampleGroupMethods.instance_variable_set("@after_each_parts", [])
        ExampleGroupMethods.instance_variable_set("@after_all_parts", [])
      end

      it "should pass before, after, and Examples to all ExampleGroup subclasses" do
        ExampleGroupMethods.before(:all) do
          ExampleGroupMethods.count.should == 1
        end

        ExampleGroupMethods.before(:each) do
          ExampleGroupMethods.count.should == 2
        end

        # TODO: BT - Enable Example inheritance
#        ExampleGroupMethods.it "should run before(:all), before(:each), example, after(:each), after(:all) in order" do
#          ExampleGroupMethods.count.should == 3
#        end

        ExampleGroupMethods.after(:each) do
          ExampleGroupMethods.count.should == 3
        end

        ExampleGroupMethods.after(:all) do
          ExampleGroupMethods.count.should == 4
        end

        @example_group = Class.new(ExampleGroup) do
          describe("example")
          it "should use ExampleGroupMethods before and after callbacks" do
          end
        end
        @example_group.examples.length.should == 1
        @example_group.suite.run
        ExampleGroupMethods.count.should == 5
      end
    end
  end
end