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

      specify "should not run context_setup or context_teardown on dry run" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test"
        
        context_setup_ran = false
        context_teardown_ran = false
        @context.context_setup { context_setup_ran = true }
        @context.context_teardown { context_teardown_ran = true }
        @context.specify("test") {true}
        @context.run(@formatter, true)
        context_setup_ran.should_be false
        context_teardown_ran.should_be false
      end

      specify "should not run context if context_setup fails" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_finished).with :any_args
        
        spec_ran = false
        @context.context_setup { raise "help" }
        @context.specify("test") {spec_ran = true}
        @context.run(@formatter)
        spec_ran.should_be false
      end

      specify "should run context_teardown if any spec fails" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_finished).with :any_args
        
        context_teardown_ran = false
        @context.context_setup { raise "context_setup error" }
        @context.context_teardown { context_teardown_ran = true }
        @context.run(@formatter)
        context_teardown_ran.should_be true
      end

      specify "should run context_teardown if any context_setup fails" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args
        
        context_teardown_ran = false
        @context.context_teardown { context_teardown_ran = true }
        @context.specify("test") {raise "spec error" }
        @context.run(@formatter)
        context_teardown_ran.should_be true
      end


      specify "should supply context_setup as spec name if failure in context_setup" do
        @formatter.should_receive(:add_context).with :any_args

        @formatter.should_receive(:spec_finished) do |name, error, location|
          name.should_eql("context_setup")
          error.message.should_eql("in context_setup")
          location.should_eql("context_setup")
        end
        
        @context.context_setup { raise "in context_setup" }
        @context.specify("test") {true}
        @context.run(@formatter)
      end

      specify "should provide context_teardown as spec name if failure in context_teardown" do
        @formatter.should_receive(:add_context).with :any_args

        @formatter.should_receive(:spec_finished) do |name, error, location|
          name.should_eql("context_teardown")
          error.message.should_eql("in context_teardown")
          location.should_eql("context_teardown")
        end
        
        @context.context_teardown { raise "in context_teardown" }
        @context.run(@formatter)
      end

      specify "should run superclass context_setup and context_setup block only once per context" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_started).with "test2"
        @formatter.should_receive(:spec_finished).twice.with :any_args

        super_class_context_setup_run_count = 0
        super_class = Class.new do
          define_method :context_setup do
            super_class_context_setup_run_count += 1
          end
        end
        @context.inherit super_class

        context_setup_run_count = 0
        @context.context_setup {context_setup_run_count += 1}
        @context.specify("test") {true}
        @context.specify("test2") {true}
        @context.run(@formatter)
        super_class_context_setup_run_count.should_be 1
        context_setup_run_count.should_be 1
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

      specify "should run superclass context_teardown method and context_teardown block only once" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_started).with "test2"
        @formatter.should_receive(:spec_finished).twice.with :any_args

        super_class_context_teardown_run_count = 0
        super_class = Class.new do
          define_method :context_teardown do
            super_class_context_teardown_run_count += 1
          end
        end
        @context.inherit super_class

        context_teardown_run_count = 0
        @context.context_teardown {context_teardown_run_count += 1}
        @context.specify("test") {true}
        @context.specify("test2") {true}
        @context.run(@formatter)
        super_class_context_teardown_run_count.should_be 1
        context_teardown_run_count.should_be 1
        @formatter.__verify
      end

      specify "context_teardown should have access to all instance variables defined in context_setup" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @context.context_setup { @instance_var = context_instance_value_in }
        @context.context_teardown { context_instance_value_out = @instance_var }
        @context.specify("test") {true}
        @context.run(@formatter)
        context_instance_value_in.should == context_instance_value_out
      end

      specify "should copy instance variables from context_setup's execution context into spec's execution context" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @context.context_setup { @instance_var = context_instance_value_in }
        @context.specify("test") {context_instance_value_out = @instance_var}
        @context.run(@formatter)
        context_instance_value_in.should == context_instance_value_out
      end

      specify "should call context_setup before any setup" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        fiddle = []
        super_class = Class.new do
          define_method :setup do
            fiddle << "superclass setup"
          end
        end
        @context.inherit super_class

        @context.context_setup { fiddle << "context_setup" }
        @context.setup { fiddle << "setup" }
        @context.specify("test") {true}
        @context.run(@formatter)
        fiddle.first.should == "context_setup"
        fiddle.last.should == "setup"
      end

      specify "should call context_teardown after any teardown" do
        @formatter.should_receive(:add_context).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        fiddle = []
        super_class = Class.new do
          define_method :teardown do
            fiddle << "superclass teardown"
          end
        end
        @context.inherit super_class

        @context.context_teardown { fiddle << "context_teardown" }
        @context.teardown { fiddle << "teardown" }
        @context.specify("test") {true}
        @context.run(@formatter)
        fiddle.first.should == "superclass teardown"
        fiddle.last.should == "context_teardown"
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
