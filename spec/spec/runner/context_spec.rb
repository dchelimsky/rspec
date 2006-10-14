require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Runner
    context "Context" do
      
      setup do
        @formatter = Spec::Mocks::Mock.new "formatter", :register_as_spec_listener => false
        @context = Context.new("context") {}
      end

      teardown do
        @formatter.__verify
      end
      
      specify "should add itself to formatter on run" do
        @formatter.should_receive(:add_context).with "context"
        @context.run(@formatter)
      end
      
      specify "should run spec on run" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test", :anything, :anything
        $spec_ran = false
        @context.specify("test") {$spec_ran = true}
        @context.run(@formatter)
        $spec_ran.should_be true
      end
         
      specify "should not run spec on dry run" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test"
        $spec_ran = false
        @context.specify("test") {$spec_ran = true}
        @context.run(@formatter, true)
        $spec_ran.should_be false
      end
      
      specify "should run superclass setup method and setup block" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        super_class_setup_ran = false
        super_class = Class.new do
          define_method :setup do
            super_class_setup_ran = true
          end
        end
        @context.inherit super_class

        setup_ran = false
        @context.setup {setup_ran = true}
        @context.specify("test") {true}
        @context.run(@formatter)
        super_class_setup_ran.should_be true
        setup_ran.should_be true
      end

      specify "should allow method definitions in setup (IS THIS OBSOLETE?)" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        $method_in_setup_called = false
        @context.setup do
          def method_in_setup
            $method_in_setup_called = true
          end
        end

        @context.specify("test") {method_in_setup}
        @context.run(@formatter)

        $method_in_setup_called.should_be true
      end

      specify "should run superclass teardown method and teardown block" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        super_class_teardown_ran = false
        super_class = Class.new do
          define_method :teardown do
            super_class_teardown_ran = true
          end
        end
        @context.inherit super_class

        teardown_ran = false
        @context.teardown {teardown_ran = true}
        @context.specify("test") {true}
        @context.run(@formatter)
        super_class_teardown_ran.should_be true
        teardown_ran.should_be true
        @formatter.__verify
      end

      specify "should have accessible methods from inherited superclass" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        helper_method_ran = false
        super_class = Class.new do
          define_method :helper_method do
            helper_method_ran = true
          end
        end
        @context.inherit super_class

        @context.specify("test") {helper_method}
        @context.run(@formatter)
        helper_method_ran.should_be true
      end

      specify "should have accessible class methods from inherited superclass" do
        class_method_ran = false
        super_class = Class.new
        (class << super_class; self; end).class_eval do
          define_method :class_method do
            class_method_ran = true
          end
        end
        @context.inherit super_class
        @context.class_method
        class_method_ran.should_be true

        lambda {@context.foobar}.should_raise(NoMethodError)
      end

      specify "should include inherited class methods" do
        class_method_ran = false
        super_class = Class.new
        class << super_class
          def super_class_class_method; end
        end
        @context.inherit super_class

        @context.methods.should_include("super_class_class_method")
      end

      specify "should have accessible methods from included module" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        mod1_method_called = false
        mod1 = Module.new do
          define_method :mod1_method do
            mod1_method_called = true
          end
        end

        mod2_method_called = false
        mod2 = Module.new do
          define_method :mod2_method do
            mod2_method_called = true
          end
        end

        @context.include mod1
        @context.include mod2

        @context.specify("test") do
          mod1_method
          mod2_method
        end
        @context.run(@formatter)
        mod1_method_called.should_be true
        mod2_method_called.should_be true
      end
      
      specify "should count number of specs" do
        @context.specify("one") {}
        @context.specify("two") {}
        @context.specify("three") {}
        @context.specify("four") {}
        @context.number_of_specs.should_be 4
      end
    end
  end
end