require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    describe ExampleGroup, "with :shared => true" do
      before(:each) do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @original_rspec_options = $rspec_options
        $rspec_options = @options
        @formatter = Spec::Mocks::Mock.new("formatter", :null_object => true)
        @options.formatters << @formatter
        @behaviour = Class.new(ExampleGroup).describe("behaviour")
        class << @behaviour
          public :include
        end
      end

      after(:each) do
        $rspec_options = @original_rspec_options
        @formatter.rspec_verify
        @behaviour = nil
        $shared_example_groups.clear unless $shared_example_groups.nil?
      end

      def make_shared_example_group(name, opts=nil, &block)
        behaviour = SharedExampleGroup.new(name, :shared => true, &block)
        SharedExampleGroup.add_shared_example_group(behaviour)
        behaviour
      end

      def non_shared_example_group()
        @non_shared_example_group ||= Class.new(ExampleGroup).describe("behaviour")
      end

      it "should accept an optional options hash" do
        lambda { Class.new(ExampleGroup).describe("context") }.should_not raise_error(Exception)
        lambda { Class.new(ExampleGroup).describe("context", :shared => true) }.should_not raise_error(Exception)
      end

      it "should return all shared behaviours" do
        b1 = make_shared_example_group("b1", :shared => true) {}
        b2 = make_shared_example_group("b2", :shared => true) {}

        b1.should_not be(nil)
        b2.should_not be(nil)

        SharedExampleGroup.find_shared_example_group("b1").should equal(b1)
        SharedExampleGroup.find_shared_example_group("b2").should equal(b2)
      end

      it "should register as shared behaviour" do
        behaviour = make_shared_example_group("behaviour") {}
        SharedExampleGroup.shared_example_groups.should include(behaviour)
      end

      it "should not be shared when not configured as shared" do
        behaviour = non_shared_example_group
        SharedExampleGroup.shared_example_groups.should_not include(behaviour)
      end

      it "should raise if run when shared" do
        behaviour = make_shared_example_group("context") {}
        $example_ran = false
        behaviour.it("test") {$example_ran = true}
        lambda { behaviour.run(@formatter) }.should raise_error
        $example_ran.should be_false
      end

      it "should contain examples when shared" do
        shared_example_group = make_shared_example_group("shared behaviour") {}
        shared_example_group.it("shared example") {}
        shared_example_group.number_of_examples.should == 1
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
        shared_example_group = Class.new(ExampleGroup).describe("shared behaviour", :shared => true)
        SharedExampleGroup.add_shared_example_group(shared_example_group)
        SharedExampleGroup.add_shared_example_group(shared_example_group)
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
        shared_example_group_1 = Class.new(ExampleGroup).describe("shared behaviour", :shared => true)
        shared_example_group_2 = Class.new(ExampleGroup).describe("shared behaviour", :shared => true)

        shared_example_group_1.description[:spec_path] = "/my/spec/a/../shared.rb"
        shared_example_group_2.description[:spec_path] = "/my/spec/b/../shared.rb"

        SharedExampleGroup.add_shared_example_group(shared_example_group_1)
        SharedExampleGroup.add_shared_example_group(shared_example_group_2)
      end

      it "should complain when adding a different shared behaviour with the same name in a different file with the same basename" do
        shared_example_group_1 = Class.new(ExampleGroup).describe("shared behaviour", :shared => true)
        shared_example_group_2 = Class.new(ExampleGroup).describe("shared behaviour", :shared => true)

        shared_example_group_1.description[:spec_path] = "/my/spec/a/shared.rb"
        shared_example_group_2.description[:spec_path] = "/my/spec/b/shared.rb"

        SharedExampleGroup.add_shared_example_group(shared_example_group_1)
        lambda do
          SharedExampleGroup.add_shared_example_group(shared_example_group_2)
        end.should raise_error(ArgumentError, /already exists/)
      end

      it "should add examples to current behaviour using it_should_behave_like" do
        shared_example_group = make_shared_example_group("shared behaviour") {}
        shared_example_group.it("shared example") {}
        shared_example_group.it("shared example 2") {}

        @behaviour.it("example") {}
        @behaviour.number_of_examples.should == 1
        @behaviour.it_should_behave_like("shared behaviour")
        @behaviour.number_of_examples.should == 3
      end

      it "should add examples to current behaviour using include" do
        shared_example_group = describe "all things", :shared => true do
          it "should do stuff" do end
        end
        
        behaviour = describe "one thing" do
          include shared_example_group
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
        shared_example_group = make_shared_example_group("shared behaviour") {}
        shared_example_group.it("shared example") { shared_example_ran = true }

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
        shared_example_group = make_shared_example_group("shared behaviour") {}
        shared_example_group.before { shared_setup_ran = true }
        shared_example_group.after { shared_teardown_ran = true }
        shared_example_group.it("shared example") { shared_example_ran = true }

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
        shared_example_group = make_shared_example_group("shared behaviour") {}
        shared_example_group.before(:all) { shared_before_all_run_count += 1}
        shared_example_group.after(:all) { shared_after_all_run_count += 1}
        shared_example_group.it("shared example") { shared_example_ran = true }

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
        @formatter.should_receive(:add_example_group).with(any_args)
        @formatter.should_receive(:example_finished).twice.with(any_args)

        shared_example_group = make_shared_example_group("shared behaviour") {}
        shared_example_group.it("shared example") { shared_example_ran = true }

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

        shared_example_group.include mod2

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
        shared_example_group = make_shared_example_group("shared behaviour xyz") do
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
          @behaviour.it_should_behave_like("non-existent shared example group")
          violated
        }.should raise_error("Shared Example Group 'non-existent shared example group' can not be found")
      end
    end
  end
end
