require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    class FakeReporter < Spec::Runner::Reporter
      attr_reader :added_behaviour
      def add_example_group(description)
        @added_behaviour = description
      end
    end
    
    describe ExampleSuite, "#run", :shared => true do
      before :all do
        @original_rspec_options = $rspec_options
      end

      before :each do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        $rspec_options = @options
        @formatter = mock("formatter", :null_object => true)
        @options.formatters << @formatter
        @options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
        @reporter = FakeReporter.new(@options)
        @options.reporter = @reporter
        @behaviour = Class.new(ExampleGroup).describe("example") do
          it "does nothing" do
          end
        end
        class << @behaviour
          public :include
        end
      end

      after :each do
        $rspec_options = @original_rspec_options
        ExampleGroup.reset!
      end
    end

    describe ExampleSuite, "#run without failure in example", :shared => true do
      it_should_behave_like "Spec::DSL::ExampleSuite#run"

      it "should not add an example failure to the TestResult" do
        suite = @behaviour.suite
        suite.run.should be_true
      end
    end

    describe ExampleSuite, "#run with failure in example", :shared => true do
      it_should_behave_like "Spec::DSL::ExampleSuite#run"
      
      it "should add an example failure to the TestResult" do
        suite = @behaviour.suite
        suite.run.should be_false
      end
    end

    describe ExampleSuite, "#run on dry run" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run"

      before do
        @options.dry_run = true
      end
    
      it "should not run before(:all) or after(:all)" do
        before_all_ran = false
        after_all_ran = false
        ExampleGroup.before(:all) { before_all_ran = true }
        ExampleGroup.after(:all) { after_all_ran = true }
        @behaviour.it("should") {}
        suite = @behaviour.suite
        suite.run
        before_all_ran.should be_false
        after_all_ran.should be_false
      end

      it "should not run example" do
        example_ran = false
        @behaviour.it("should") {example_ran = true}
        suite = @behaviour.suite
        suite.run
        example_ran.should be_false
      end
    end

    describe ExampleSuite, "#run with success" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run without failure in example"

      before do
        @special_behaviour = Class.new(ExampleGroup)
        ExampleGroupFactory.register(:special, @special_behaviour)
        @not_special_behaviour = Class.new(ExampleGroup)
        ExampleGroupFactory.register(:not_special, @not_special_behaviour)
      end

      after do
        ExampleGroupFactory.reset!
      end

      it "should send reporter add_example_group" do
        suite = @behaviour.suite
        suite.run
        @reporter.added_behaviour.should == "example"
      end

      it "should run example on run" do
        example_ran = false
        @behaviour.it("should") {example_ran = true}
        suite = @behaviour.suite
        suite.run
        example_ran.should be_true
      end

      it "should run before(:all) block only once" do
        before_all_run_count_run_count = 0
        @behaviour.before(:all) {before_all_run_count_run_count += 1}
        @behaviour.it("test") {true}
        @behaviour.it("test2") {true}
        suite = @behaviour.suite
        suite.run
        before_all_run_count_run_count.should == 1
      end

      it "should run after(:all) block only once" do
        after_all_run_count = 0
        @behaviour.after(:all) {after_all_run_count += 1}
        @behaviour.it("test") {true}
        @behaviour.it("test2") {true}
        suite = @behaviour.suite
        suite.run
        after_all_run_count.should == 1
        @reporter.rspec_verify
      end

      it "after(:all) should have access to all instance variables defined in before(:all)" do
        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @behaviour.before(:all) { @instance_var = context_instance_value_in }
        @behaviour.after(:all) { context_instance_value_out = @instance_var }
        @behaviour.it("test") {true}
        suite = @behaviour.suite
        suite.run
        context_instance_value_in.should == context_instance_value_out
      end

      it "should copy instance variables from before(:all)'s execution context into spec's execution context" do
        context_instance_value_in = "Hello there"
        context_instance_value_out = ""
        @behaviour.before(:all) { @instance_var = context_instance_value_in }
        @behaviour.it("test") {context_instance_value_out = @instance_var}
        suite = @behaviour.suite
        suite.run
        context_instance_value_in.should == context_instance_value_out
      end

      it "should not add global before callbacks for untargetted behaviours" do
        fiddle = []

        ExampleGroup.before(:all) { fiddle << "Example.before(:all)" }
        ExampleGroup.prepend_before(:all) { fiddle << "Example.prepend_before(:all)" }
        @special_behaviour.before(:each) { fiddle << "Example.before(:each, :behaviour_type => :special)" }
        @special_behaviour.prepend_before(:each) { fiddle << "Example.prepend_before(:each, :behaviour_type => :special)" }
        @special_behaviour.before(:all) { fiddle << "Example.before(:all, :behaviour_type => :special)" }
        @special_behaviour.prepend_before(:all) { fiddle << "Example.prepend_before(:all, :behaviour_type => :special)" }

        behaviour = Class.new(ExampleGroup).describe("I'm not special", :behaviour_type => :not_special) do
          it "does nothing"
        end
        suite = behaviour.suite
        suite.run
        fiddle.should == [
          'Example.prepend_before(:all)',
          'Example.before(:all)',
        ]
      end

      it "should add global before callbacks for targetted behaviours" do
        fiddle = []

        ExampleGroup.before(:all) { fiddle << "Example.before(:all)" }
        ExampleGroup.prepend_before(:all) { fiddle << "Example.prepend_before(:all)" }
        @special_behaviour.before(:each) { fiddle << "special.before(:each, :behaviour_type => :special)" }
        @special_behaviour.prepend_before(:each) { fiddle << "special.prepend_before(:each, :behaviour_type => :special)" }
        @special_behaviour.before(:all) { fiddle << "special.before(:all, :behaviour_type => :special)" }
        @special_behaviour.prepend_before(:all) { fiddle << "special.prepend_before(:all, :behaviour_type => :special)" }
        @special_behaviour.append_before(:each) { fiddle << "special.append_before(:each, :behaviour_type => :special)" }
        
        behaviour = Class.new(@special_behaviour).describe("I'm a special behaviour") {}
        behaviour.it("test") {true}
        suite = behaviour.suite
        suite.run
        fiddle.should == [
          'Example.prepend_before(:all)',
          'Example.before(:all)',
          'special.prepend_before(:all, :behaviour_type => :special)',
          'special.before(:all, :behaviour_type => :special)',
          'special.prepend_before(:each, :behaviour_type => :special)',
          'special.before(:each, :behaviour_type => :special)',
          'special.append_before(:each, :behaviour_type => :special)',
        ]
      end

      it "should order before callbacks from global to local" do
        fiddle = []
        ExampleGroup.prepend_before(:all) { fiddle << "Example.prepend_before(:all)" }
        ExampleGroup.before(:all) { fiddle << "Example.before(:all)" }
        @behaviour.prepend_before(:all) { fiddle << "prepend_before(:all)" }
        @behaviour.before(:all) { fiddle << "before(:all)" }
        @behaviour.prepend_before(:each) { fiddle << "prepend_before(:each)" }
        @behaviour.before(:each) { fiddle << "before(:each)" }
        suite = @behaviour.suite
        suite.run
        fiddle.should == [
          'Example.prepend_before(:all)',
          'Example.before(:all)',
          'prepend_before(:all)',
          'before(:all)',
          'prepend_before(:each)',
          'before(:each)'
        ]
      end

      it "should order after callbacks from local to global" do
        @reporter.should_receive(:add_example_group).with any_args()
        @reporter.should_receive(:example_finished).with any_args()

        fiddle = []
        @behaviour.after(:each) { fiddle << "after(:each)" }
        @behaviour.append_after(:each) { fiddle << "append_after(:each)" }
        @behaviour.after(:all) { fiddle << "after(:all)" }
        @behaviour.append_after(:all) { fiddle << "append_after(:all)" }
        ExampleGroup.after(:all) { fiddle << "Example.after(:all)" }
        ExampleGroup.append_after(:all) { fiddle << "Example.append_after(:all)" }
        suite = @behaviour.suite
        suite.run
        fiddle.should == [
          'after(:each)',
          'append_after(:each)',
          'after(:all)',
          'append_after(:all)',
          'Example.after(:all)',
          'Example.append_after(:all)'
        ]
      end

      it "should have accessible instance methods from included module" do
        @reporter.should_receive(:add_example_group).with any_args()
        @reporter.should_receive(:example_finished).with any_args()

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

        @behaviour.include mod1, mod2

        @behaviour.it("test") do
          mod1_method
          mod2_method
        end
        suite = @behaviour.suite
        suite.run
        mod1_method_called.should be_true
        mod2_method_called.should be_true
      end

      it "should include targetted modules included using configuration" do
        mod1 = Module.new
        mod2 = Module.new
        mod3 = Module.new
        Spec::Runner.configuration.include(mod1, mod2)
        Spec::Runner.configuration.include(mod3, :behaviour_type => :not_special)

        behaviour = Class.new(@special_behaviour).describe("I'm special", :behaviour_type => :special) do
          it "does nothing"
        end
        suite = behaviour.suite
        suite.run

        behaviour.included_modules.should include(mod1)
        behaviour.included_modules.should include(mod2)
        behaviour.included_modules.should_not include(mod3)
      end

      it "should include any predicate_matchers included using configuration" do
        $included_predicate_matcher_found = false
        Spec::Runner.configuration.predicate_matchers[:do_something] = :does_something?
        behaviour = Class.new(ExampleGroup).describe('example') do
          it "should respond to do_something" do
            $included_predicate_matcher_found = respond_to?(:do_something)
          end
        end
        suite = behaviour.suite
        suite.run
        $included_predicate_matcher_found.should be(true)
      end

      it "should use a mock framework set up in config" do
        mod = Module.new do
          class << self
            def included(mod)
              $included_module = mod
            end
          end
        end

        begin
          $included_module = nil
          Spec::Runner.configuration.mock_with mod

          behaviour = Class.new(ExampleGroup).describe('example') do
            it "does nothing"
          end
          suite = behaviour.suite
          suite.run

          $included_module.should_not be_nil
        ensure
          Spec::Runner.configuration.mock_with :rspec
        end
      end
    end

    describe ExampleSuite, "#run with pending example that has a failing assertion" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run without failure in example"

      before do
        @behaviour.it("should be pending") do
          pending("Example fails") {false.should be_true}
        end
      end

      it "should send example_pending to formatter" do
        @formatter.should_receive(:example_pending).with("example", "should be pending", "Example fails")
        suite = @behaviour.suite
        suite.run
      end
    end

    describe ExampleSuite, "#run with pending example that does not have a failing assertion" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run with failure in example"

      before do
        @behaviour.it("should be pending") do
          pending("Example passes") {true.should be_true}
        end
      end

      it "should send example_pending to formatter" do
        @formatter.should_receive(:example_pending).with("example", "should be pending", "Example passes")
        suite = @behaviour.suite
        suite.run
      end
    end

    describe ExampleSuite, "#run when before(:all) fails" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run"

      before do
        ExampleGroup.before(:all) { raise NonStandardError, "before(:all) failure" }
      end

      it "should not run any example" do
        spec_ran = false
        @behaviour.it("test") {spec_ran = true}
        suite = @behaviour.suite
        suite.run
        spec_ran.should be_false
      end

      it "should run after(:all)" do
        after_all_ran = false
        ExampleGroup.after(:all) { after_all_ran = true }
        suite = @behaviour.suite
        suite.run
        after_all_ran.should be_true
      end

      it "should not run any example" do
        spec_ran = false
        @behaviour.it("test") {spec_ran = true}
        suite = @behaviour.suite
        suite.run
        spec_ran.should be_false
      end

      it "should run after(:all)" do
        after_all_ran = false
        @behaviour.after(:all) { after_all_ran = true }
        suite = @behaviour.suite
        suite.run
        after_all_ran.should be_true
      end

      it "should supply before(:all) as description" do
        @reporter.should_receive(:example_finished) do |example, error, location|
          example.description.should eql("before(:all)")
          error.message.should eql("before(:all) failure")
          location.should eql("before(:all)")
        end

        @behaviour.it("test") {true}
        suite = @behaviour.suite
        suite.run
      end
    end

    describe ExampleSuite, "#run when before(:each) fails" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run with failure in example"

      before do
        ExampleGroup.before(:each) { raise NonStandardError }
      end
      
      it "should run after(:all)" do
        after_all_ran = false
        ExampleGroup.after(:all) { after_all_ran = true }
        suite = @behaviour.suite
        suite.run
        after_all_ran.should be_true
      end
    end

    describe ExampleSuite, "#run when any example fails" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run with failure in example"

      before do
        @behaviour.it("should") { raise NonStandardError }
      end
      
      it "should run after(:all)" do
        after_all_ran = false
        ExampleGroup.after(:all) { after_all_ran = true }
        suite = @behaviour.suite
        suite.run
        after_all_ran.should be_true
      end
    end

    describe ExampleSuite, "#run when first after(:each) block fails" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run"

      it "should add an example failure to the TestResult" do
        second_after_ran = false
        @behaviour.after(:each) do
          second_after_ran = true
        end
        first_after_ran = false
        @behaviour.after(:each) do
          first_after_ran = true
          raise "first"
        end
        
        suite = @behaviour.suite
        suite.run.should be_false
      end      
      
      it "should run second after(:each) block" do
        second_after_ran = false
        @behaviour.after(:each) do
          second_after_ran = true
        end
        first_after_ran = false
        @behaviour.after(:each) do
          first_after_ran = true
          raise "first"
        end

        @reporter.should_receive(:example_finished) do |example, error, location|
          example.should equal(example)
          error.message.should eql("first")
          location.should eql("after(:each)")
        end
        suite = @behaviour.suite
        suite.run
        first_after_ran.should be_true
        second_after_ran.should be_true
      end
    end

    describe ExampleSuite, "#run when first before(:each) block fails" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run"

      it "should add an example failure to the TestResult" do
        first_before_ran = false
        @behaviour.before(:each) do
          first_before_ran = true
          raise "first"
        end
        second_before_ran = false
        @behaviour.before(:each) do
          second_before_ran = true
        end
        
        suite = @behaviour.suite
        suite.run.should be_false
      end

      it "should not run second before(:each)" do
        first_before_ran = false
        @behaviour.before(:each) do
          first_before_ran = true
          raise "first"
        end
        second_before_ran = false
        @behaviour.before(:each) do
          second_before_ran = true
        end

        @reporter.should_receive(:example_finished) do |name, error, location, example_not_implemented|
          name.should eql("example")
          error.message.should eql("first")
          location.should eql("before(:each)")
          example_not_implemented.should be_false
        end
        suite = @behaviour.suite
        suite.run
        first_before_ran.should be_true
        second_before_ran.should be_false
      end
    end

    describe ExampleSuite, "#run when failure in after(:all)" do
      it_should_behave_like "Spec::DSL::ExampleSuite#run"

      before do
        ExampleGroup.after(:all) { raise NonStandardError, "in after(:all)" }
      end

      it "should return false" do
        suite = @behaviour.suite
        suite.run.should be_false
      end      

      it "should provide after(:all) as description" do
        @reporter.should_receive(:example_finished) do |example, error, location|
          example.description.should eql("after(:all)")
          error.message.should eql("in after(:all)")
          location.should eql("after(:all)")
        end

        suite = @behaviour.suite
        suite.run
      end
    end

    describe ExampleSuite, "#size" do
      it "returns the number of examples in the behaviour" do
        behaviour = Class.new(ExampleGroup).describe("Some Examples") do
          it("does something") {}
          it("does something else") {}
        end
        suite = behaviour.suite
        suite.size.should == 2
      end
    end

    describe ExampleSuite, "#empty?" do
      it "when there are examples; returns true" do
        behaviour = Class.new(ExampleGroup).describe("Some Examples") do
          it("does something") {}
        end
        suite = behaviour.suite
        suite.size.should be > 0

        suite.should_not be_empty
      end

      it "when there are no examples; returns true" do
        behaviour = Class.new(ExampleGroup).describe("Some Examples") do
        end
        suite = behaviour.suite
        suite.size.should == 0

        suite.should be_empty
      end
    end

    describe ExampleSuite, "#delete" do
      it "removes the passed in example" do
        behaviour = Class.new(ExampleGroup).describe("Some Examples") do
          it("does something") {}
        end
        suite = behaviour.suite
        suite.delete(suite.examples.first)

        suite.should be_empty
      end
    end
  end
end
