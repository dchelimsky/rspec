require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe Behaviour do
      setup do
        @formatter = Spec::Mocks::Mock.new "formatter"
        @behaviour = Behaviour.new("context") {}
      end

      teardown do
        @formatter.rspec_verify
      end

      it "should add itself to formatter on run" do
        @formatter.should_receive(:add_behaviour).with "context"
        @behaviour.run(@formatter)
      end
      
      it "should run spec on run" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with "test", :anything, :anything
        $spec_ran = false
        @behaviour.specify("test") {$spec_ran = true}
        @behaviour.run(@formatter)
        $spec_ran.should be_true
      end
         
      it "should not run spec on dry run" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with "test"
        $spec_ran = false
        @behaviour.specify("test") {$spec_ran = true}
        @behaviour.run(@formatter, true)
        $spec_ran.should be_false
      end

      it "should not run before(:all) or after(:all) on dry run" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with "test"
        
        before_all_ran = false
        after_all_ran = false
        @behaviour.before(:all) { before_all_ran = true }
        @behaviour.after(:all) { after_all_ran = true }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter, true)
        before_all_ran.should be_false
        after_all_ran.should be_false
      end

      it "should not run context if before(:all) fails" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args
        
        spec_ran = false
        @behaviour.before(:all) { raise "help" }
        @behaviour.specify("test") {spec_ran = true}
        @behaviour.run(@formatter)
        spec_ran.should be_false
      end

      it "should run after(:all) if any spec fails" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args
        
        after_all_ran = false
        @behaviour.before(:all) { raise "before all error" }
        @behaviour.after(:all) { after_all_ran = true }
        @behaviour.run(@formatter)
        after_all_ran.should be_true
      end

      it "should run after(:all) if any before(:all) fails" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args
        
        after_all_ran = false
        @behaviour.after(:all) { after_all_ran = true }
        @behaviour.specify("test") { raise "spec error" }
        @behaviour.run(@formatter)
        after_all_ran.should be_true
      end


      it "should supply before(:all) as spec name if failure in before(:all)" do
        @formatter.should_receive(:add_behaviour).with :any_args

        @formatter.should_receive(:example_finished) do |name, error, location|
          name.should eql("before(:all)")
          error.message.should eql("in before(:all)")
          location.should eql("before(:all)")
        end
        
        @behaviour.before(:all) { raise "in before(:all)" }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
      end

      it "should provide after(:all) as spec name if failure in after(:all)" do
        @formatter.should_receive(:add_behaviour).with :any_args

        @formatter.should_receive(:example_finished) do |name, error, location|
          name.should eql("after(:all)")
          error.message.should eql("in after(:all)")
          location.should eql("after(:all)")
        end
        
        @behaviour.after(:all) { raise "in after(:all)" }
        @behaviour.run(@formatter)
      end

      it "should run superclass context_setup and context_setup block only once per context" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).twice.with :any_args

        super_class_context_setup_run_count = 0
        super_class = Class.new do
          define_method :context_setup do
            super_class_context_setup_run_count += 1
          end
        end
        @behaviour.inherit(super_class)

        context_setup_run_count = 0
        @behaviour.before(:all) {context_setup_run_count += 1}
        @behaviour.specify("test") {true}
        @behaviour.specify("test2") {true}
        @behaviour.run(@formatter)
        super_class_context_setup_run_count.should == 1
        context_setup_run_count.should == 1
      end
      
      it "should run superclass setup method and setup block" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args

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

      it "should run superclass context_teardown method and after(:all) block only once" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).twice.with :any_args

        super_class_context_teardown_run_count = 0
        super_class = Class.new do
          define_method :context_teardown do
            super_class_context_teardown_run_count += 1
          end
        end
        @behaviour.inherit super_class

        context_teardown_run_count = 0
        @behaviour.after(:all) {context_teardown_run_count += 1}
        @behaviour.specify("test") {true}
        @behaviour.specify("test2") {true}
        @behaviour.run(@formatter)
        super_class_context_teardown_run_count.should == 1
        context_teardown_run_count.should == 1
        @formatter.rspec_verify
      end

      it "after(:all) should have access to all instance variables defined in before(:all)" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args

        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @behaviour.before(:all) { @instance_var = context_instance_value_in }
        @behaviour.after(:all) { context_instance_value_out = @instance_var }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        context_instance_value_in.should == context_instance_value_out
      end

      it "should copy instance variables from before(:all)'s execution context into spec's execution context" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args

        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @behaviour.before(:all) { @instance_var = context_instance_value_in }
        @behaviour.specify("test") {context_instance_value_out = @instance_var}
        @behaviour.run(@formatter)
        context_instance_value_in.should == context_instance_value_out
      end

      it "should call before(:all) before any setup" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args

        fiddle = []
        super_class = Class.new do
          define_method :setup do
            fiddle << "superclass setup"
          end
        end
        @behaviour.inherit super_class

        @behaviour.before(:all) { fiddle << "before(:all)" }
        @behaviour.setup { fiddle << "setup" }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        fiddle.first.should == "before(:all)"
        fiddle.last.should == "setup"
      end

      it "should call after(:all) after any teardown" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args

        fiddle = []
        super_class = Class.new do
          define_method :teardown do
            fiddle << "superclass teardown"
          end
        end
        @behaviour.inherit super_class

        @behaviour.after(:all) { fiddle << "after(:all)" }
        @behaviour.teardown { fiddle << "teardown" }
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        fiddle.first.should == "superclass teardown"
        fiddle.last.should == "after(:all)"
      end


      it "should run superclass teardown method and after block" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args

        super_class_teardown_ran = false
        super_class = Class.new do
          define_method :teardown do
            super_class_teardown_ran = true
          end
        end
        @behaviour.inherit super_class

        teardown_ran = false
        @behaviour.after {teardown_ran = true}
        @behaviour.specify("test") {true}
        @behaviour.run(@formatter)
        super_class_teardown_ran.should be_true
        teardown_ran.should be_true
        @formatter.rspec_verify
      end

      it "should have accessible methods from inherited superclass" do
        @formatter.should_receive(:add_behaviour).with :any_args
        @formatter.should_receive(:example_finished).with :any_args

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
        @formatter.should_receive(:example_finished).with :any_args

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
          
          metaclass.class_eval do
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
          
          metaclass.class_eval do
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
        @behaviour.number_of_examples.should == 4
      end
      
      it "should not match anything when there are no examples" do
        @behaviour.should_not be_matches(['context'])
      end

      it "should match when one of the examples match" do
        example = mock('my example')
        example.should_receive(:matches?).and_return(true)
        @behaviour.stub!(:examples).and_return([example])
        @behaviour.should be_matches(['jalla'])
      end
    
      it "should support deprecated context_setup and context_teardown" do
        formatter = mock("formatter", :null_object => true)
        behaviour = Behaviour.new('example') do
          context_setup {}
          context_teardown {}
        end.run(formatter)
      end
    end
    
    class BehaviourSubclass < Behaviour
      public :described_type
    end

    describe Behaviour, " subclass" do
      it "should have access to the described_type" do
        BehaviourSubclass.new(Describable.new(Example)){}.described_type.should == Example
      end
    end
  end
end
