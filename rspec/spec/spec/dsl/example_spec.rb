require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    class FakeReporter < Spec::Runner::Reporter
      attr_reader :added_behaviour
      def add_example_group(description)
        @added_behaviour = description
      end
    end

    describe ExampleGroup, :shared => true do
      before :all do
        @original_rspec_options = $rspec_options
      end

      before :each do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        $rspec_options = @options
        @options.formatters << mock("formatter", :null_object => true)
        @options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
        @reporter = FakeReporter.new(@options)
        @options.reporter = @reporter
        @example_group = Class.new(ExampleGroup).describe("example") do
          it "does nothing"
        end
        class << @example_group
          public :include
        end
        @result = nil
      end

      after :each do
        $rspec_options = @original_rspec_options
        ExampleGroup.reset!
      end
    end
    
    describe ExampleGroup, ".it" do
      it_should_behave_like "Spec::DSL::ExampleGroup"

      it "should should create an example instance" do
        lambda {
          @example_group.it("")
        }.should change(@example_group.examples, :length).by(1)
      end
    end

    describe ExampleGroup, ".xit" do
      it_should_behave_like "Spec::DSL::ExampleGroup"
      
      before(:each) do
        Kernel.stub!(:warn)
      end
      
      it "should NOT  should create an example instance" do
        lambda {
          @example_group.xit("")
        }.should_not change(@example_group.examples, :length)
      end
      
      it "should warn that it is disabled" do
        Kernel.should_receive(:warn).with("Example disabled: foo")
        @example_group.xit("foo")
      end
    end

    describe ExampleGroup, ".suite" do
      it_should_behave_like "Spec::DSL::ExampleGroup"

      it "should return an empty ExampleSuite when there is no description" do
        ExampleGroup.description.should be_nil
        ExampleGroup.suite.should be_instance_of(ExampleSuite)
        ExampleGroup.suite.tests.should be_empty
      end

      it "should return an ExampleSuite with Examples" do
        behaviour = Class.new(ExampleGroup).describe('example') do
          it "should pass" do
            1.should == 1
          end
        end
        suite = behaviour.suite
        suite.tests.length.should == 1
        suite.tests.first.example.description.should == "should pass"
      end

      it "should include methods that begin with test and has an arity of 0 in suite" do
        behaviour = Class.new(ExampleGroup).describe('example') do
          def test_any_args(*args)
            true.should be_true
          end
          def test_something
            1.should == 1
          end
          def test
            raise "This is not a real test"
          end
          def testify
            raise "This is not a real test"
          end
        end
        suite = behaviour.suite
        suite.tests.length.should == 2
        descriptions = suite.tests.collect {|test| test.example.description}.sort
        descriptions.should == ["test_any_args", "test_something"]
      end

      it "should include methods that begin with should and has an arity of 0 in suite" do
        behaviour = Class.new(ExampleGroup).describe('example') do
          def shouldCamelCase
            true.should be_true
          end
          def should_any_args(*args)
            true.should be_true
          end
          def should_something
            1.should == 1
          end
          def should_not_something
            1.should_not == 2
          end
          def should
            raise "This is not a real example"
          end
          def should_not
            raise "This is not a real example"
          end
        end
        behaviour = behaviour.dup
        suite = behaviour.suite
        suite.tests.length.should == 4
        descriptions = suite.tests.collect {|test| test.example.description}.sort
        descriptions.should include("shouldCamelCase")
        descriptions.should include("should_any_args")
        descriptions.should include("should_something")
        descriptions.should include("should_not_something")
      end

      it "should not include methods that begin with test_ and has an arity > 0 in suite" do
        behaviour = Class.new(ExampleGroup).describe('example') do
          def test_invalid(foo)
            1.should == 1
          end
          def testInvalidCamelCase(foo)
            1.should == 1
          end
        end
        suite = behaviour.suite
        suite.tests.length.should == 0
      end

      it "should not include methods that begin with should_ and has an arity > 0 in suite" do
        behaviour = Class.new(ExampleGroup).describe('example') do
          def should_invalid(foo)
            1.should == 1
          end
          def shouldInvalidCamelCase(foo)
            1.should == 1
          end
          def should_not_invalid(foo)
            1.should == 1
          end
        end
        suite = behaviour.suite
        suite.tests.length.should == 0
      end
    end

    describe ExampleGroup, ".description" do
      it_should_behave_like "Spec::DSL::ExampleGroup"

      it "should return the same description instance for each call" do
        @example_group.description.should eql(@example_group.description)
      end
    end

    describe ExampleGroup, ".run" do
      it_should_behave_like "Spec::DSL::ExampleGroup"
    end
    
    describe ExampleGroup, ".remove_after" do
      it_should_behave_like "Spec::DSL::ExampleGroup"

      it "should unregister a given after(:each) block" do
        after_all_ran = false
        @example_group.it("example") {}
        proc = Proc.new { after_all_ran = true }
        ExampleGroup.after(:each, &proc)
        suite = @example_group.suite
        suite.run
        after_all_ran.should be_true

        after_all_ran = false
        ExampleGroup.remove_after(:each, &proc)
        suite = @example_group.suite
        suite.run
        after_all_ran.should be_false
      end
    end

    describe ExampleGroup, ".include" do
      it_should_behave_like "Spec::DSL::ExampleGroup"

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

        @example_group.include mod1, mod2

        @example_group.mod1_method
        @example_group.mod2_method
        mod1_method_called.should be_true
        mod2_method_called.should be_true
      end
    end

    describe ExampleGroup, ".number_of_examples" do
      it_should_behave_like "Spec::DSL::ExampleGroup"

      it "should count number of specs" do
        @example_group.examples.clear
        @example_group.it("one") {}
        @example_group.it("two") {}
        @example_group.it("three") {}
        @example_group.it("four") {}
        @example_group.number_of_examples.should == 4
      end
    end

    class ExampleModuleScopingSpec < ExampleGroup
      describe ExampleGroup, " via a class definition"

      module Foo
        module Bar
          def self.loaded?
            true
          end
        end
      end
      include Foo

      it "should understand module scoping" do
        Bar.should be_loaded
      end

      @@foo = 1

      it "should allow class variables to be defined" do
        @@foo.should == 1
      end      
    end

    class ExampleClassVariablePollutionSpec < ExampleGroup
      describe ExampleGroup, " via a class definition without a class variable"

      it "should not retain class variables from other Example classes" do
        proc do
          @@foo
        end.should raise_error
      end
    end

    describe ExampleGroup, ".class_eval" do
      it_should_behave_like "Spec::DSL::ExampleGroup"

      it "should allow constants to be defined" do
        behaviour = Class.new(ExampleGroup).describe('example') do
          FOO = 1
          it "should reference FOO" do
            FOO.should == 1
          end
        end
        suite = behaviour.suite
        suite.run
        Object.const_defined?(:FOO).should == false
      end
    end

    describe ExampleGroup, '.run functional example' do
      def count
        @count ||= 0
        @count = @count + 1
        @count
      end

      before(:all) do
        count.should == 1
      end

      before(:all) do
        count.should == 2
      end

      before(:each) do
        count.should == 3
      end

      before(:each) do
        count.should == 4
      end

      it "should run before(:all), before(:each), example, after(:each), after(:all) in order" do
        count.should == 5
      end

      after(:each) do
        count.should == 7
      end

      after(:each) do
        count.should == 6
      end

      after(:all) do
        count.should == 9
      end

      after(:all) do
        count.should == 8
      end
    end

    describe ExampleGroup, "#initialize" do
      the_behaviour = self
      it "should have copy of behaviour" do
        the_behaviour.superclass.should == ExampleGroup
      end
    end

    describe ExampleGroup, "#pending" do
      it "should raise a Pending error when its block fails" do
        block_ran = false
        lambda {
          pending("something") do
            block_ran = true
            raise "something wrong with my example"
          end
        }.should raise_error(Spec::DSL::ExamplePendingError, "something")
        block_ran.should == true
      end

      it "should raise Spec::DSL::PendingExampleFixedError when its block does not fail" do
        block_ran = false
        lambda {
          pending("something") do
            block_ran = true
          end
        }.should raise_error(Spec::DSL::PendingExampleFixedError, "Expected pending 'something' to fail. No Error was raised.")
        block_ran.should == true
      end
    end
    
    describe ExampleGroup, "#run" do
      before do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @original_rspec_options = $rspec_options
        $rspec_options = @options
      end

      after do
        $rspec_options = @original_rspec_options
      end

      it "should not run when there are no examples" do
        behaviour = Class.new(ExampleGroup).describe("Foobar") {}
        behaviour.examples.should be_empty

        reporter = mock("Reporter")
        reporter.should_not_receive(:add_example_group)
        suite = behaviour.suite
        suite.run
      end
    end
    
    class ExampleSubclass < ExampleGroup
    end

    describe ExampleGroup, "subclasses" do
      after do
        ExampleGroupFactory.reset!
      end

      it "should have access to the described_type" do
        behaviour = Class.new(ExampleSubclass).describe(Array){}
        behaviour.send(:described_type).should == Array
      end
    end

    describe Enumerable do
      def each(&block)
        ["4", "2", "1"].each(&block)
      end

      it "should be included in examples because it is a module" do
        map{|e| e.to_i}.should == [4,2,1]
      end
    end

    describe "An", Enumerable, "as a second argument" do
      def each(&block)
        ["4", "2", "1"].each(&block)
      end

      it "should be included in examples because it is a module" do
        map{|e| e.to_i}.should == [4,2,1]
      end
    end

    describe String do
      it "should not be included in examples because it is not a module" do
        lambda{self.map}.should raise_error(NoMethodError, /undefined method `map' for/)
      end
    end
  end
end
