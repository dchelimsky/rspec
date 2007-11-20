require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe "ExampleMethods" do
      before do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @options.formatters << mock("formatter", :null_object => true)
        @options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
        @reporter = FakeReporter.new(@options)
        @options.reporter = @reporter

        ExampleMethods.before_all_parts.should == []
        ExampleMethods.before_each_parts.should == []
        ExampleMethods.after_each_parts.should == []
        ExampleMethods.after_all_parts.should == []
        def ExampleMethods.count
          @count ||= 0
          @count = @count + 1
          @count
        end
      end

      after do
        ExampleMethods.instance_variable_set("@before_all_parts", [])
        ExampleMethods.instance_variable_set("@before_each_parts", [])
        ExampleMethods.instance_variable_set("@after_each_parts", [])
        ExampleMethods.instance_variable_set("@after_all_parts", [])
        ExampleMethods.__send__(:remove_method, @example_method.method_name)
      end

      it "should pass before, after, and Examples to all ExampleGroup subclasses" do
        ExampleMethods.before(:all) do
          ExampleMethods.count.should == 1
        end

        ExampleMethods.before(:each) do
          ExampleMethods.count.should == 2
        end

        @example_method = ExampleMethods.it "should run before(:all), before(:each), example, after(:each), after(:all) in order" do
          ExampleMethods.count.should == 3
        end

        ExampleMethods.after(:each) do
          ExampleMethods.count.should == 4
        end

        ExampleMethods.after(:all) do
          ExampleMethods.count.should == 5
        end

        @example_group = Class.new(ExampleGroup)
        @example_group.examples.length.should == 1
        @example_group.suite.run
        ExampleMethods.count.should == 6
      end
    end
  end
end