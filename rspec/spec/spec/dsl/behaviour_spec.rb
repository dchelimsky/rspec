require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe Behaviour do
      
      setup do
        @formatter = Spec::Mocks::Mock.new "formatter", :register_as_spec_listener => false
        @behaviour = Behaviour.new("context") {}
      end

      teardown do
        @formatter.__verify
      end
      
      it "should add itself to formatter on run" do
        @formatter.should_receive(:add_behaviour).with "context"
        @behaviour.run(@formatter)
      end
      
      it "should run spec on run" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test", :anything, :anything
        $spec_ran = false
        @behaviour.specify("test") {$spec_ran = true}
        @behaviour.run(@formatter)
        $spec_ran.should be_true
      end
         
      it "should not run spec on dry run" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test"
        $spec_ran = false
        @behaviour.specify("test") {$spec_ran = true}
        @behaviour.run(@formatter, true)
        $spec_ran.should be_false
      end

      it "should not run context_setup or context_teardown on dry run" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with "test"
        
        context_setup_ran = false
        context_teardown_ran = false
        @behaviour.context_setup { context_setup_ran = true }
        @behaviour.context_teardown { context_teardown_ran = true }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter, true)
        context_setup_ran.should be_false
        context_teardown_ran.should be_false
      end

      it "should not run context if context_setup fails" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_finished).with :any_args
        
        spec_ran = false
        @behaviour.context_setup { raise "help" }
        @behaviour.specify("test") {spec_ran = true}
        @behaviour.run(@formatter)
        spec_ran.should be_false
      end

      it "should run context_teardown if any spec fails" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_finished).with :any_args
        
        context_teardown_ran = false
        @behaviour.context_setup { raise "context_setup error" }
        @behaviour.context_teardown { context_teardown_ran = true }
        @behaviour.run(@formatter)
        context_teardown_ran.should be_true
      end

      it "should run context_teardown if any context_setup fails" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args
        
        context_teardown_ran = false
        @behaviour.context_teardown { context_teardown_ran = true }
        @behaviour.specify("test") {raise "spec error" }
        @behaviour.run(@formatter)
        context_teardown_ran.should be_true
      end


      it "should supply context_setup as spec name if failure in context_setup" do
        @formatter.should_receive(:add_behaviour).with :any_args

        @formatter.should_receive(:spec_finished) do |name, error, location|
          name.should eql("context_setup")
          error.message.should eql("in context_setup")
          location.should eql("context_setup")
        end
        
        @behaviour.context_setup { raise "in context_setup" }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
      end

      it "should provide context_teardown as spec name if failure in context_teardown" do
        @formatter.should_receive(:add_behaviour).with :any_args

        @formatter.should_receive(:spec_finished) do |name, error, location|
          name.should eql("context_teardown")
          error.message.should eql("in context_teardown")
          location.should eql("context_teardown")
        end
        
        @behaviour.context_teardown { raise "in context_teardown" }
        @behaviour.run(@formatter)
      end

      it "should run superclass context_setup and context_setup block only once per context" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_started).with "test2"
        @formatter.should_receive(:spec_finished).twice.with :any_args

        super_class_context_setup_run_count = 0
        super_class = Class.new do
          define_method :context_setup do
            super_class_context_setup_run_count += 1
          end
        end
        # using @behaviour.inherit_context_eval_module_from here, but other examples use @behaviour.inherit
        # - inherit_context_eval_module_from is used by Spec::Rails to avoid confusion with Ruby's #include method
        @behaviour.inherit_context_eval_module_from super_class

        context_setup_run_count = 0
        @behaviour.context_setup {context_setup_run_count += 1}
        @behaviour.specify("test") {true}
        @behaviour.specify("test2") {true}
        @behaviour.run(@formatter)
        super_class_context_setup_run_count.should == 1
        context_setup_run_count.should == 1
      end
      
      it "should run superclass setup method and setup block" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        super_class_setup_ran = false
        super_class = Class.new do
          define_method :setup do
            super_class_setup_ran = true
          end
        end
        @behaviour.inherit super_class

        setup_ran = false
        @behaviour.setup {setup_ran = true}
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        super_class_setup_ran.should be_true
        setup_ran.should be_true
      end

      it "should run superclass context_teardown method and context_teardown block only once" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_started).with "test2"
        @formatter.should_receive(:spec_finished).twice.with :any_args

        super_class_context_teardown_run_count = 0
        super_class = Class.new do
          define_method :context_teardown do
            super_class_context_teardown_run_count += 1
          end
        end
        @behaviour.inherit super_class

        context_teardown_run_count = 0
        @behaviour.context_teardown {context_teardown_run_count += 1}
        @behaviour.specify("test") {true}
        @behaviour.specify("test2") {true}
        @behaviour.run(@formatter)
        super_class_context_teardown_run_count.should == 1
        context_teardown_run_count.should == 1
        @formatter.__verify
      end

      it "context_teardown should have access to all instance variables defined in context_setup" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @behaviour.context_setup { @instance_var = context_instance_value_in }
        @behaviour.context_teardown { context_instance_value_out = @instance_var }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        context_instance_value_in.should == context_instance_value_out
      end

      it "should copy instance variables from context_setup's execution context into spec's execution context" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @behaviour.context_setup { @instance_var = context_instance_value_in }
        @behaviour.specify("test") {context_instance_value_out = @instance_var}
        @behaviour.run(@formatter)
        context_instance_value_in.should == context_instance_value_out
      end

      it "should call context_setup before any setup" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        fiddle = []
        super_class = Class.new do
          define_method :setup do
            fiddle << "superclass setup"
          end
        end
        @behaviour.inherit super_class

        @behaviour.context_setup { fiddle << "context_setup" }
        @behaviour.setup { fiddle << "setup" }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        fiddle.first.should == "context_setup"
        fiddle.last.should == "setup"
      end

      it "should call context_teardown after any teardown" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        fiddle = []
        super_class = Class.new do
          define_method :teardown do
            fiddle << "superclass teardown"
          end
        end
        @behaviour.inherit super_class

        @behaviour.context_teardown { fiddle << "context_teardown" }
        @behaviour.teardown { fiddle << "teardown" }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        fiddle.first.should == "superclass teardown"
        fiddle.last.should == "context_teardown"
      end


      it "should run superclass teardown method and teardown block" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        super_class_teardown_ran = false
        super_class = Class.new do
          define_method :teardown do
            super_class_teardown_ran = true
          end
        end
        @behaviour.inherit super_class

        teardown_ran = false
        @behaviour.teardown {teardown_ran = true}
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        super_class_teardown_ran.should be_true
        teardown_ran.should be_true
        @formatter.__verify
      end

      it "should have accessible methods from inherited superclass" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:spec_started).with "test"
        @formatter.should_receive(:spec_finished).with :any_args

        helper_method_ran = false
        super_class = Class.new do
          define_method :helper_method do
            helper_method_ran = true
          end
        end
        @behaviour.inherit super_class

        @behaviour.specify("test") {helper_method}
        @behaviour.run(@formatter)
        helper_method_ran.should be_true
      end

      it "should have accessible class methods from inherited superclass" do
        class_method_ran = false
        super_class = Class.new
        (class << super_class; self; end).class_eval do
          define_method :class_method do
            class_method_ran = true
          end
        end
        @behaviour.inherit super_class
        @behaviour.class_method
        class_method_ran.should be_true

        lambda {@behaviour.foobar}.should raise_error(NoMethodError)
      end

      it "should include inherited class methods" do
        class_method_ran = false
        super_class = Class.new
        class << super_class
          def super_class_class_method; end
        end
        @behaviour.inherit super_class

        @behaviour.methods.should include("super_class_class_method")
      end

      it "should have accessible instance methods from included module" do
        @formatter.should_receive(:add_behaviour).with :any_args
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

        @behaviour.include mod1
        @behaviour.include mod2

        @behaviour.specify("test") do
          mod1_method
          mod2_method
        end
        @behaviour.run(@formatter)
        mod1_method_called.should be_true
        mod2_method_called.should be_true
      end
      
      it "should have accessible class methods from included module" do
        mod1_method_called = false
        mod1 = Module.new do
          class_methods = Module.new do
              define_method :mod1_method do
                mod1_method_called = true
              end
          end
          
          (class << self; self; end).class_eval do
            define_method(:included) do |receiver|
              receiver.extend class_methods
            end
          end
        end

        mod2_method_called = false
        mod2 = Module.new do
          class_methods = Module.new do
              define_method :mod2_method do
                mod2_method_called = true
              end
          end
          
          (class << self; self; end).class_eval do
            define_method(:included) do |receiver|
              receiver.extend class_methods
            end
          end
        end

        @behaviour.include mod1
        @behaviour.include mod2

        @behaviour.mod1_method
        @behaviour.mod2_method
        mod1_method_called.should be_true
        mod2_method_called.should be_true
      end
      
      it "should count number of specs" do
        @behaviour.specify("one") {}
        @behaviour.specify("two") {}
        @behaviour.specify("three") {}
        @behaviour.specify("four") {}
        @behaviour.number_of_specs.should == 4
      end
    end
  end
end
