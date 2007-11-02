require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe Example, ", with :shared => true" do
      before(:each) do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @original_rspec_options = $rspec_options
        $rspec_options = @options
        @formatter = Spec::Mocks::Mock.new("formatter", :null_object => true)
        @options.formatters << @formatter
        @behaviour = Class.new(Example).describe("behaviour")
        class << @behaviour
          public :include
        end
      end

      after(:each) do
        $rspec_options = @original_rspec_options
        @formatter.rspec_verify
        @behaviour_class = nil
        $shared_behaviours.clear unless $shared_behaviours.nil?
      end

      def make_shared_behaviour(name, opts=nil, &block)
        behaviour = SharedBehaviour.new(name, :shared => true, &block)
        SharedBehaviour.add_shared_behaviour(behaviour)
        behaviour
      end

      def non_shared_behaviour()
        @non_shared_behaviour ||= Class.new(Example).describe("behaviour")
      end

      it "should accept an optional options hash" do
        lambda { Class.new(Example).describe("context") }.should_not raise_error(Exception)
        lambda { Class.new(Example).describe("context", :shared => true) }.should_not raise_error(Exception)
      end

      it "should return all shared behaviours" do
        b1 = make_shared_behaviour("b1", :shared => true) {}
        b2 = make_shared_behaviour("b2", :shared => true) {}

        b1.should_not be(nil)
        b2.should_not be(nil)

        SharedBehaviour.find_shared_behaviour("b1").should equal(b1)
        SharedBehaviour.find_shared_behaviour("b2").should equal(b2)
      end

      it "should register as shared behaviour" do
        behaviour = make_shared_behaviour("behaviour") {}
        SharedBehaviour.shared_behaviours.should include(behaviour)
      end

      it "should not be shared when not configured as shared" do
        behaviour = non_shared_behaviour
        SharedBehaviour.shared_behaviours.should_not include(behaviour)
      end

      it "should raise if run when shared" do
        behaviour = make_shared_behaviour("context") {}
        $example_ran = false
        behaviour.it("test") {$example_ran = true}
        lambda { behaviour.run(@formatter) }.should raise_error
        $example_ran.should be_false
      end

      it "should contain examples when shared" do
        shared_behaviour = make_shared_behaviour("shared behaviour") {}
        shared_behaviour.it("shared example") {}
        shared_behaviour.number_of_examples.should == 1
      end

      it "should complain when adding a second shared behaviour with the same description" do
        describe "shared behaviour", :shared => true do
        end
        lambda do
          describe "shared behaviour", :shared => true do
          end
        end.should raise_error(ArgumentError)
      end

      it "should NOT complain when adding the same shared behaviour instance again" do
        shared_behaviour = Class.new(Example).describe("shared behaviour", :shared => true)
        SharedBehaviour.add_shared_behaviour(shared_behaviour)
        SharedBehaviour.add_shared_behaviour(shared_behaviour)
      end

      it "should NOT complain when adding the same shared behaviour again (i.e. file gets reloaded)" do
        lambda do
          2.times do
            describe "shared behaviour which gets loaded twice", :shared => true do
            end
          end
        end.should_not raise_error(ArgumentError)
      end

      it "should NOT complain when adding the same shared behaviour in same file with different absolute path" do
        shared_behaviour_1 = Class.new(Example).describe("shared behaviour", :shared => true)
        shared_behaviour_2 = Class.new(Example).describe("shared behaviour", :shared => true)

        shared_behaviour_1.description[:spec_path] = "/my/spec/a/../shared.rb"
        shared_behaviour_2.description[:spec_path] = "/my/spec/b/../shared.rb"

        SharedBehaviour.add_shared_behaviour(shared_behaviour_1)
        SharedBehaviour.add_shared_behaviour(shared_behaviour_2)
      end

      it "should complain when adding a different shared behaviour with the same name in a different file with the same basename" do
        shared_behaviour_1 = Class.new(Example).describe("shared behaviour", :shared => true)
        shared_behaviour_2 = Class.new(Example).describe("shared behaviour", :shared => true)

        shared_behaviour_1.description[:spec_path] = "/my/spec/a/shared.rb"
        shared_behaviour_2.description[:spec_path] = "/my/spec/b/shared.rb"

        SharedBehaviour.add_shared_behaviour(shared_behaviour_1)
        lambda do
          SharedBehaviour.add_shared_behaviour(shared_behaviour_2)
        end.should raise_error(ArgumentError, /already exists/)
      end

      it "should add examples to current behaviour using it_should_behave_like" do
        shared_behaviour = make_shared_behaviour("shared behaviour") {}
        shared_behaviour.it("shared example") {}
        shared_behaviour.it("shared example 2") {}

        @behaviour.it("example") {}
        @behaviour.number_of_examples.should == 1
        @behaviour.it_should_behave_like("shared behaviour")
        @behaviour.number_of_examples.should == 3
      end

      it "should add examples to current behaviour using include" do
        shared_behaviour = describe "all things", :shared => true do
          it "should do stuff" do end
        end
        
        behaviour = describe "one thing" do
          include shared_behaviour
        end
        
        behaviour.number_of_examples.should == 1
      end

      it "should add examples to current behaviour using it_should_behave_like with a module" do
        AllThings = describe "all things", :shared => true do
          it "should do stuff" do end
        end
        
        behaviour = describe "one thing" do
          it_should_behave_like AllThings
        end
        
        behaviour.number_of_examples.should == 1
      end

      it "should run shared examples" do
        shared_example_ran = false
        shared_behaviour = make_shared_behaviour("shared behaviour") {}
        shared_behaviour.it("shared example") { shared_example_ran = true }

        example_ran = false

        @behaviour.it_should_behave_like("shared behaviour")
        @behaviour.it("example") {example_ran = true}
        suite = @behaviour.suite
        suite.run
        example_ran.should be_true
        shared_example_ran.should be_true
      end

      it "should run setup and teardown from shared behaviour" do
        shared_setup_ran = false
        shared_teardown_ran = false
        shared_behaviour = make_shared_behaviour("shared behaviour") {}
        shared_behaviour.before { shared_setup_ran = true }
        shared_behaviour.after { shared_teardown_ran = true }
        shared_behaviour.it("shared example") { shared_example_ran = true }

        example_ran = false

        @behaviour.it_should_behave_like("shared behaviour")
        @behaviour.it("example") {example_ran = true}
        suite = @behaviour.suite
        suite.run
        example_ran.should be_true
        shared_setup_ran.should be_true
        shared_teardown_ran.should be_true
      end

      it "should run before(:all) and after(:all) only once from shared behaviour" do
        shared_before_all_run_count = 0
        shared_after_all_run_count = 0
        shared_behaviour = make_shared_behaviour("shared behaviour") {}
        shared_behaviour.before(:all) { shared_before_all_run_count += 1}
        shared_behaviour.after(:all) { shared_after_all_run_count += 1}
        shared_behaviour.it("shared example") { shared_example_ran = true }

        example_ran = false

        @behaviour.it_should_behave_like("shared behaviour")
        @behaviour.it("example") {example_ran = true}
        suite = @behaviour.suite
        suite.run
        example_ran.should be_true
        shared_before_all_run_count.should == 1
        shared_after_all_run_count.should == 1
      end

      it "should include modules, included into shared behaviour, into current behaviour" do
        @formatter.should_receive(:add_behaviour).with(any_args)
        @formatter.should_receive(:example_finished).twice.with(any_args)

        shared_behaviour = make_shared_behaviour("shared behaviour") {}
        shared_behaviour.it("shared example") { shared_example_ran = true }

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

        shared_behaviour.include mod2

        @behaviour.it_should_behave_like("shared behaviour")
        @behaviour.include mod1

        @behaviour.it("test") do
          mod1_method
          mod2_method
        end
        suite = @behaviour.suite
        suite.run
        mod1_method_called.should be_true
        mod2_method_called.should be_true
      end

      it "should make methods defined in the shared behaviour available in consuming behaviour" do
        shared_behaviour = make_shared_behaviour("shared behaviour xyz") do
          def a_shared_helper_method
            "this got defined in a shared behaviour"
          end
        end
        @behaviour.it_should_behave_like("shared behaviour xyz")
        success = false
        @behaviour.it("should access a_shared_helper_method") do
          a_shared_helper_method
          success = true
        end
        suite = @behaviour.suite
        suite.run
        success.should be_true
      end

      it "should raise when named shared behaviour can not be found" do
        lambda {
          @behaviour.it_should_behave_like("non-existent shared behaviour")
          violated
        }.should raise_error("Shared Example 'non-existent shared behaviour' can not be found")
      end
    end
  end
end
