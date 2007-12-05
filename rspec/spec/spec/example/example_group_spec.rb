require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Example
    describe ExampleGroup do
      attr_reader :options, :example_group, :result, :reporter
      before(:all) do
        @original_rspec_options = $rspec_options
      end

      before(:each) do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        $rspec_options = @options
        options.formatters << mock("formatter", :null_object => true)
        options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
        @reporter = FakeReporter.new(@options)
        options.reporter = reporter
        @example_group = Class.new(ExampleGroup) do
          describe("example")
          it "does nothing"
        end
        class << example_group
          public :include
        end
        @result = nil
      end

      after(:each) do
        $rspec_options = @original_rspec_options
        ExampleGroup.reset
      end

      describe ExampleGroup, ".describe" do
        attr_reader :child_example_group
        before do
          @child_example_group = @example_group.describe("Another ExampleGroup") do
            it "should pass" do
              true.should be_true
            end
          end
        end

        it "should create a subclass of the ExampleGroup when passed a block" do
          child_example_group.superclass.should == @example_group
          @options.example_groups.should include(child_example_group)
        end

        it "should not inherit examples" do
          child_example_group.examples.length.should == 1
        end
      end

      describe ExampleGroup, ".it" do
        it "should should create an example instance" do
          lambda {
            @example_group.it("")
          }.should change { @example_group.examples.length }.by(1)
        end
      end

      describe ExampleGroup, ".xit" do
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

      describe ExampleGroup, ".examples" do
        it "should have Examples" do
          example_group = Class.new(ExampleGroup) do
            describe('example')
            it "should pass" do
              1.should == 1
            end
          end
          example_group.examples.length.should == 1
          example_group.examples.first.description.should == "should pass"
        end

        it "should not include methods that begin with test (only when TU interop is loaded)" do
          example_group = Class.new(ExampleGroup) do
            describe('example')
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
          example_group.examples.length.should == 0
          example_group.run.should be_true
        end

        it "should include methods that begin with should and has an arity of 0 in suite" do
          example_group = Class.new(ExampleGroup) do
            describe('example')
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
          example_group = example_group.dup
          example_group.examples.length.should == 4
          descriptions = example_group.examples.collect {|example| example.description}.sort
          descriptions.should include("shouldCamelCase")
          descriptions.should include("should_any_args")
          descriptions.should include("should_something")
          descriptions.should include("should_not_something")
        end

        it "should not include methods that begin with test_ and has an arity > 0 in suite" do
          example_group = Class.new(ExampleGroup) do
            describe('example')
            def test_invalid(foo)
              1.should == 1
            end
            def testInvalidCamelCase(foo)
              1.should == 1
            end
          end
          example_group.examples.length.should == 0
        end

        it "should not include methods that begin with should_ and has an arity > 0 in suite" do
          example_group = Class.new(ExampleGroup) do
            describe('example')
            def should_invalid(foo)
              1.should == 2
            end
            def shouldInvalidCamelCase(foo)
              1.should == 3
            end
            def should_not_invalid(foo)
              1.should == 4
            end
            def should_valid
              1.should == 1
            end
          end
          example_group.examples.length.should == 1
          example_group.run.should be_true
        end

        it "should run should_methods" do
          example_group = Class.new(ExampleGroup) do
            def should_valid
              1.should == 2
            end
          end
          example_group.examples.length.should == 1
          example_group.run.should be_false
        end
      end

      describe ExampleGroup, ".description" do
        it "should return the same description instance for each call" do
          @example_group.description.should eql(@example_group.description)
        end
      end

      describe ExampleGroup, ".remove_after" do
        it "should unregister a given after(:each) block" do
          after_all_ran = false
          @example_group.it("example") {}
          proc = Proc.new { after_all_ran = true }
          ExampleGroup.after(:each, &proc)
          @example_group.run
          after_all_ran.should be_true

          after_all_ran = false
          ExampleGroup.remove_after(:each, &proc)
          @example_group.run
          after_all_ran.should be_false
        end
      end

      describe ExampleGroup, ".include" do
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
        it "should count number of specs" do
          proc do
            @example_group.it("one") {}
            @example_group.it("two") {}
            @example_group.it("three") {}
            @example_group.it("four") {}
          end.should change {@example_group.number_of_examples}.by(4)
        end
      end

      describe ExampleGroup, ".class_eval" do
        it "should allow constants to be defined" do
          example_group = Class.new(ExampleGroup) do
            describe('example')
            FOO = 1
            it "should reference FOO" do
              FOO.should == 1
            end
          end
          example_group.run
          Object.const_defined?(:FOO).should == false
        end
      end

      describe ExampleGroup, '.register' do
        it "should add ExampleGroup to set of ExampleGroups to be run" do
          example_group.register
          options.example_groups.should include(example_group)
        end
      end

      describe ExampleGroup, '.unregister' do
        before do
          example_group.register
          options.example_groups.should include(example_group)
        end

        it "should remove ExampleGroup from set of ExampleGroups to be run" do
          example_group.unregister
          options.example_groups.should_not include(example_group)
        end
      end
    end

    class ExampleModuleScopingSpec < ExampleGroup
      describe ExampleGroup, "via a class definition"

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
      describe ExampleGroup, "via a class definition without a class variable"

      it "should not retain class variables from other Example classes" do
        proc do
          @@foo
        end.should raise_error
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
      the_example_group = self
      it "should have copy of example_group" do
        the_example_group.superclass.should == ExampleGroup
      end

      it "should set instance variables from passed in hash" do
        instance_variables = {
          '@foo' => 'bar',
          '@test' => 1
        }
        example_group_instance = ExampleGroup.new(nil, instance_variables)
        example_group_instance.instance_variable_get('@foo').should == 'bar'
        example_group_instance.instance_variable_get('@test').should == 1
      end

      it "should overwrite @_example, even if its to be set" do
        instance_variables = {
          '@_example' => 'should not be this value'
        }
        example = Example.new
        example_group_instance = ExampleGroup.new(example, instance_variables)
        example_group_instance.instance_variable_get('@_example').should == example
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
        }.should raise_error(Spec::Example::ExamplePendingError, "something")
        block_ran.should == true
      end

      it "should raise Spec::Example::PendingExampleFixedError when its block does not fail" do
        block_ran = false
        lambda {
          pending("something") do
            block_ran = true
          end
        }.should raise_error(Spec::Example::PendingExampleFixedError, "Expected pending 'something' to fail. No Error was raised.")
        block_ran.should == true
      end
    end

    describe ExampleGroup, "#run with failure in example", :shared => true do
      it "should add an example failure to the TestResult" do
        example_group.run.should be_false
      end
    end
    
    describe ExampleGroup, "#run" do
      attr_reader :example_group, :options, :formatter, :reporter
      before :all do
        @original_rspec_options = $rspec_options
      end

      before :each do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        $rspec_options = options
        @formatter = mock("formatter", :null_object => true)
        options.formatters << formatter
        options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
        @reporter = FakeReporter.new(options)
        options.reporter = reporter
        @example_group = Class.new(ExampleGroup) do
          describe("example")
          it "does nothing" do
          end
        end
        class << example_group
          public :include
        end
      end

      after :each do
        $rspec_options = @original_rspec_options
        ExampleGroup.reset
      end

      it "should not run when there are no examples" do
        example_group = Class.new(ExampleGroup) do
          describe("Foobar")
        end
        example_group.examples.should be_empty

        reporter = mock("Reporter")
        reporter.should_not_receive(:add_example_group)
        example_group.run
      end

      describe ExampleGroup, "#run when passed examples" do
        it "should only run the passed in examples" do
          not_run_example = example_group.it("should not be run") do
            raise "this example should not be run"
          end
          examples = example_group.examples
          examples.delete(not_run_example)
          example_group.run(examples).should be_true
        end
      end

      describe ExampleGroup, "#run on dry run" do
        before do
          @options.dry_run = true
        end

        it "should not run before(:all) or after(:all)" do
          before_all_ran = false
          after_all_ran = false
          ExampleGroup.before(:all) { before_all_ran = true }
          ExampleGroup.after(:all) { after_all_ran = true }
          example_group.it("should") {}
          example_group.run
          before_all_ran.should be_false
          after_all_ran.should be_false
        end

        it "should not run example" do
          example_ran = false
          example_group.it("should") {example_ran = true}
          example_group.run
          example_ran.should be_false
        end
      end

      describe ExampleGroup, "#run with specified examples" do
        attr_reader :examples_that_were_run
        before do
          @examples_that_were_run = []
        end

        describe ExampleGroup, "#run when specified_examples matches entire ExampleGroup" do
          before do
            examples_that_were_run = @examples_that_were_run
            @example_group = Class.new(ExampleGroup) do
              describe("the ExampleGroup")
              it("should be run") do
                examples_that_were_run << 'should be run'
              end

              it("should also be run") do
                examples_that_were_run << 'should also be run'
              end
            end
            options.examples = ["the ExampleGroup"]
          end

          it "should not run the Examples in the ExampleGroup" do
            example_group.run
            examples_that_were_run.should == ['should be run', 'should also be run']
          end
        end

        describe ExampleGroup, "#run when specified_examples matches only Example description" do
          before do
            examples_that_were_run = @examples_that_were_run
            @example_group = Class.new(ExampleGroup) do
              describe("example")
              it("should be run") do
                examples_that_were_run << 'should be run'
              end
            end
            options.examples = ["should be run"]
          end

          it "should not run the example" do
            example_group.run
            examples_that_were_run.should == ['should be run']
          end
        end

        describe ExampleGroup, "#run when specified_examples does not match an Example description" do
          before do
            examples_that_were_run = @examples_that_were_run
            @example_group = Class.new(ExampleGroup) do
              describe("example")
              it("should be something else") do
                examples_that_were_run << 'should be something else'
              end
            end
            options.examples = ["does not match anything"]
          end

          it "should not run the example" do
            example_group.run
            examples_that_were_run.should == []
          end
        end

        describe ExampleGroup, "#run when specified_examples matches an Example description" do
          before do
            examples_that_were_run = @examples_that_were_run
            @example_group = Class.new(ExampleGroup) do
              describe("example")
              it("should be run") do
                examples_that_were_run << 'should be run'
              end
              it("should not be run") do
                examples_that_were_run << 'should not be run'
              end
            end
            options.examples = ["should be run"]
          end

          it "should run only the example, when there in only one" do
            example_group.run
            examples_that_were_run.should == ["should be run"]
          end

          it "should run only the one example" do
            example_group.run
            examples_that_were_run.should == ["should be run"]          end
        end
      end

      describe ExampleGroup, "#run with success" do        
        before do
          @special_example_group = Class.new(ExampleGroup)
          ExampleGroupFactory.register(:special, @special_example_group)
          @not_special_example_group = Class.new(ExampleGroup)
          ExampleGroupFactory.register(:not_special, @not_special_example_group)
        end

        after do
          ExampleGroupFactory.reset
        end

        it "should send reporter add_example_group" do
          example_group.run
          reporter.example_groups.should == [example_group]
        end 

        it "should run example on run" do
          example_ran = false
          example_group.it("should") {example_ran = true}
          example_group.run
          example_ran.should be_true
        end

        it "should run before(:all) block only once" do
          before_all_run_count_run_count = 0
          example_group.before(:all) {before_all_run_count_run_count += 1}
          example_group.it("test") {true}
          example_group.it("test2") {true}
          example_group.run
          before_all_run_count_run_count.should == 1
        end

        it "should run after(:all) block only once" do
          after_all_run_count = 0
          example_group.after(:all) {after_all_run_count += 1}
          example_group.it("test") {true}
          example_group.it("test2") {true}
          example_group.run
          after_all_run_count.should == 1
          @reporter.rspec_verify
        end

        it "after(:all) should have access to all instance variables defined in before(:all)" do
          context_instance_value_in = "Hello there"
          context_instance_value_out = ""
          example_group.before(:all) { @instance_var = context_instance_value_in }
          example_group.after(:all) { context_instance_value_out = @instance_var }
          example_group.it("test") {true}
          example_group.run
          context_instance_value_in.should == context_instance_value_out
        end

        it "should copy instance variables from before(:all)'s execution context into spec's execution context" do
          context_instance_value_in = "Hello there"
          context_instance_value_out = ""
          example_group.before(:all) { @instance_var = context_instance_value_in }
          example_group.it("test") {context_instance_value_out = @instance_var}
          example_group.run
          context_instance_value_in.should == context_instance_value_out
        end

        it "should not add global before callbacks for untargetted example_group" do
          fiddle = []

          ExampleGroup.before(:all) { fiddle << "Example.before(:all)" }
          ExampleGroup.prepend_before(:all) { fiddle << "Example.prepend_before(:all)" }
          @special_example_group.before(:each) { fiddle << "Example.before(:each, :type => :special)" }
          @special_example_group.prepend_before(:each) { fiddle << "Example.prepend_before(:each, :type => :special)" }
          @special_example_group.before(:all) { fiddle << "Example.before(:all, :type => :special)" }
          @special_example_group.prepend_before(:all) { fiddle << "Example.prepend_before(:all, :type => :special)" }

          example_group = Class.new(ExampleGroup) do
            describe("I'm not special", :type => :not_special)
            it "does nothing"
          end
          example_group.run
          fiddle.should == [
            'Example.prepend_before(:all)',
            'Example.before(:all)',
          ]
        end

        it "should add global before callbacks for targetted example_groups" do
          fiddle = []

          ExampleGroup.before(:all) { fiddle << "Example.before(:all)" }
          ExampleGroup.prepend_before(:all) { fiddle << "Example.prepend_before(:all)" }
          @special_example_group.before(:each) { fiddle << "special.before(:each, :type => :special)" }
          @special_example_group.prepend_before(:each) { fiddle << "special.prepend_before(:each, :type => :special)" }
          @special_example_group.before(:all) { fiddle << "special.before(:all, :type => :special)" }
          @special_example_group.prepend_before(:all) { fiddle << "special.prepend_before(:all, :type => :special)" }
          @special_example_group.append_before(:each) { fiddle << "special.append_before(:each, :type => :special)" }

          example_group = Class.new(@special_example_group).describe("I'm a special example_group") {}
          example_group.it("test") {true}
          example_group.run
          fiddle.should == [
            'Example.prepend_before(:all)',
            'Example.before(:all)',
            'special.prepend_before(:all, :type => :special)',
            'special.before(:all, :type => :special)',
            'special.prepend_before(:each, :type => :special)',
            'special.before(:each, :type => :special)',
            'special.append_before(:each, :type => :special)',
          ]
        end

        it "should order before callbacks from global to local" do
          fiddle = []
          ExampleGroup.prepend_before(:all) { fiddle << "Example.prepend_before(:all)" }
          ExampleGroup.before(:all) { fiddle << "Example.before(:all)" }
          example_group.prepend_before(:all) { fiddle << "prepend_before(:all)" }
          example_group.before(:all) { fiddle << "before(:all)" }
          example_group.prepend_before(:each) { fiddle << "prepend_before(:each)" }
          example_group.before(:each) { fiddle << "before(:each)" }
          example_group.run
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
          fiddle = []
          example_group.after(:each) { fiddle << "after(:each)" }
          example_group.append_after(:each) { fiddle << "append_after(:each)" }
          example_group.after(:all) { fiddle << "after(:all)" }
          example_group.append_after(:all) { fiddle << "append_after(:all)" }
          ExampleGroup.after(:all) { fiddle << "Example.after(:all)" }
          ExampleGroup.append_after(:all) { fiddle << "Example.append_after(:all)" }
          example_group.run
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

          example_group.include mod1, mod2

          example_group.it("test") do
            mod1_method
            mod2_method
          end
          example_group.run
          mod1_method_called.should be_true
          mod2_method_called.should be_true
        end

        it "should include targetted modules included using configuration" do
          mod1 = Module.new
          mod2 = Module.new
          mod3 = Module.new
          Spec::Runner.configuration.include(mod1, mod2)
          Spec::Runner.configuration.include(mod3, :type => :not_special)

          example_group = Class.new(@special_example_group).describe("I'm special", :type => :special) do
            it "does nothing"
          end
          example_group.run

          example_group.included_modules.should include(mod1)
          example_group.included_modules.should include(mod2)
          example_group.included_modules.should_not include(mod3)
        end

        it "should include any predicate_matchers included using configuration" do
          $included_predicate_matcher_found = false
          Spec::Runner.configuration.predicate_matchers[:do_something] = :does_something?
          example_group = Class.new(ExampleGroup) do
            describe('example')
            it "should respond to do_something" do
              $included_predicate_matcher_found = respond_to?(:do_something)
            end
          end
          example_group.run
          $included_predicate_matcher_found.should be(true)
        end

        it "should use a mock framework set up in config" do
          mod = Module.new do
            class << self
              def included(mod)
                $included_module = mod
              end
            end
            
            def teardown_mocks_for_rspec
              $torn_down = true
            end
          end

          begin
            $included_module = nil
            $torn_down = true
            Spec::Runner.configuration.mock_with mod

            example_group = Class.new(ExampleGroup) do
              describe('example')
              it "does nothing"
            end
            example_group.run

            $included_module.should_not be_nil
            $torn_down.should == true
          ensure
            Spec::Runner.configuration.mock_with :rspec
          end
        end
      end

      describe ExampleGroup, "#run with pending example that has a failing assertion" do
        before do
          example_group.it("should be pending") do
            pending("Example fails") {false.should be_true}
          end
        end

        it "should send example_pending to formatter" do
          @formatter.should_receive(:example_pending).with("example", "should be pending", "Example fails")
          example_group.run
        end
      end

      describe ExampleGroup, "#run with pending example that does not have a failing assertion" do
        it_should_behave_like "Spec::Example::ExampleGroup#run with failure in example"

        before do
          example_group.it("should be pending") do
            pending("Example passes") {true.should be_true}
          end
        end

        it "should send example_pending to formatter" do
          @formatter.should_receive(:example_pending).with("example", "should be pending", "Example passes")
          example_group.run
        end
      end

      describe ExampleGroup, "#run when before(:all) fails" do
        it_should_behave_like "Spec::Example::ExampleGroup#run with failure in example"
        
        before do
          ExampleGroup.before(:all) { raise NonStandardError, "before(:all) failure" }
        end

        it "should not run any example" do
          spec_ran = false
          example_group.it("test") {spec_ran = true}
          example_group.run
          spec_ran.should be_false
        end

        it "should run ExampleGroup after(:all)" do
          after_all_ran = false
          ExampleGroup.after(:all) { after_all_ran = true }
          example_group.run
          after_all_ran.should be_true
        end

        it "should run example_group after(:all)" do
          after_all_ran = false
          example_group.after(:all) { after_all_ran = true }
          example_group.run
          after_all_ran.should be_true
        end

        it "should supply before(:all) as description" do
          @reporter.should_receive(:failure) do |example, error|
            example.should eql("before(:all)")
            error.message.should eql("before(:all) failure")
          end

          example_group.it("test") {true}
          example_group.run
        end
      end

      describe ExampleGroup, "#run when before(:each) fails" do
        it_should_behave_like "Spec::Example::ExampleGroup#run with failure in example"
        
        before do
          ExampleGroup.before(:each) { raise NonStandardError }
        end

        it "should run after(:all)" do
          after_all_ran = false
          ExampleGroup.after(:all) { after_all_ran = true }
          example_group.run
          after_all_ran.should be_true
        end
      end

      describe ExampleGroup, "#run when any example fails" do
        it_should_behave_like "Spec::Example::ExampleGroup#run with failure in example"
        
        before do
          example_group.it("should") { raise NonStandardError }
        end

        it "should run after(:all)" do
          after_all_ran = false
          ExampleGroup.after(:all) { after_all_ran = true }
          example_group.run
          after_all_ran.should be_true
        end
      end

      describe ExampleGroup, "#run when first after(:each) block fails" do
        it_should_behave_like "Spec::Example::ExampleGroup#run with failure in example"

        before do
          class << example_group
            attr_accessor :first_after_ran, :second_after_ran
          end
          example_group.first_after_ran = false
          example_group.second_after_ran = false

          example_group.after(:each) do
            self.class.second_after_ran = true
          end
          example_group.after(:each) do
            self.class.first_after_ran = true
            raise "first"
          end
        end
        
        it "should run second after(:each) block" do
          reporter.should_receive(:example_finished) do |example, error|
            example.should equal(example)
            error.message.should eql("first")
          end
          example_group.run
          example_group.first_after_ran.should be_true
          example_group.second_after_ran.should be_true
        end
      end

      describe ExampleGroup, "#run when first before(:each) block fails" do
        it_should_behave_like "Spec::Example::ExampleGroup#run with failure in example"

        before do
          class << example_group
            attr_accessor :first_before_ran, :second_before_ran
          end
          example_group.first_before_ran = false
          example_group.second_before_ran = false

          example_group.before(:each) do
            self.class.first_before_ran = true
            raise "first"
          end
          example_group.before(:each) do
            self.class.second_before_ran = true
          end
        end
        
        it "should not run second before(:each)" do
          reporter.should_receive(:example_finished) do |name, error|
            error.message.should eql("first")
          end
          example_group.run
          example_group.first_before_ran.should be_true
          example_group.second_before_ran.should be_false
        end
      end

      describe ExampleGroup, "#run when failure in after(:all)" do
        it_should_behave_like "Spec::Example::ExampleGroup#run with failure in example"
        
        before do
          ExampleGroup.after(:all) { raise NonStandardError, "in after(:all)" }
        end

        it "should return false" do
          example_group.run.should be_false
        end
      end
    end

    class ExampleSubclass < ExampleGroup
    end

    describe ExampleGroup, "subclasses" do
      after do
        ExampleGroupFactory.reset
      end

      it"should have access to the described_type" do
        example_group = Class.new(ExampleSubclass) do
          describe(Array)
        end
        example_group.send(:described_type).should == Array
      end
      
      it "should concat descriptions when nested" do
        example_group = Class.new(ExampleSubclass) do
          describe(Array)
          $nested_group = describe("when empty") do
          end
        end
        $nested_group.description.to_s.should == "Array when empty"
      end
    end

    describe Enumerable do
      def each(&block)
        ["4", "2", "1"].each(&block)
      end

      it"should be included in examples because it is a module" do
        map{|e| e.to_i}.should == [4,2,1]
      end
    end

    describe "An", Enumerable, "as a second argument" do
      def each(&block)
        ["4", "2", "1"].each(&block)
      end

      it"should be included in examples because it is a module" do
        map{|e| e.to_i}.should == [4,2,1]
      end
    end

    describe String do
      it"should not be included in examples because it is not a module" do
        lambda{self.map}.should raise_error(NoMethodError, /undefined method `map' for/)
      end
    end
  end
end
