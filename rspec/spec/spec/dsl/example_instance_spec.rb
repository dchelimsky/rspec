require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe ExampleRunner, "#run", :shared => true do
      before(:each) do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @reporter = ::Spec::Runner::Reporter.new(@options)
        @options.reporter = @reporter
        @behaviour = Class.new(Example).describe("My Behaviour") {}
      end

      def create_proxy(example_definition)
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        proxy.stub!(:verify_mocks)
        proxy.stub!(:teardown_mocks)
        proxy
      end
    end

    describe ExampleRunner, "#run with blank passing example" do
      it_should_behave_like "Spec::DSL::ExampleRunner#run"

      before do
        @example_definition = @behaviour.create_example_definition("example") {}
        @proxy = create_proxy(@example_definition)
      end
      
      it "should send reporter example_started" do
        @reporter.should_receive(:example_started).with(equal(@example_definition))
        @proxy.run
      end

      it "should report its name for dry run" do
        @options.dry_run = true
        @reporter.should_receive(:example_finished).with(equal(@example_definition), nil, "example")
        @proxy.run
      end

      it "should report success" do
        @reporter.should_receive(:example_finished).with(equal(@example_definition), nil, nil, false)
        @proxy.run
      end
    end

    describe ExampleRunner, "#run with a failing example" do
      predicate_matchers[:is_a] = [:is_a?]
      it_should_behave_like "Spec::DSL::ExampleRunner#run"

      before do
        @example_definition = @behaviour.create_example_definition("example") do
          (2+2).should == 5
        end
        @proxy = create_proxy(@example_definition)
      end

      it "should report failure due to failure" do
        @reporter.should_receive(:example_finished).with(
          equal(@example_definition),
          is_a(Spec::Expectations::ExpectationNotMetError),
          "example",
          false
        )
        @proxy.run
      end
    end

    describe ExampleRunner, "#run with a erroring example" do
      it_should_behave_like "Spec::DSL::ExampleRunner#run"

      before do
        @error = error = NonStandardError.new("in body")
        @example_definition = @behaviour.create_example_definition("example") do
          raise(error)
        end
        @proxy = create_proxy(@example_definition)
      end

      it "should report failure due to error" do
        @reporter.should_receive(:example_finished).with(
          equal(@example_definition),
          @error,
          "example",
          false
        )
        @proxy.run
      end

      it "should run after_each block" do
        @behaviour.after(:each) do
          raise("in after_each")
        end
        @reporter.should_receive(:example_finished) do |example_definition, error, location|
          example_definition.should equal(@example_definition)
          location.should eql("example")
          error.message.should eql("in body")
        end
        @proxy.run
      end      
    end

    describe ExampleRunner, "#run where before_each fails" do
      it_should_behave_like "Spec::DSL::ExampleRunner#run"

      before do
        @example_ran = example_ran = false
        @example_definition = @behaviour.create_example_definition("should not run") do
          example_ran = true
        end
        @proxy = create_proxy(@example_definition)
        @behaviour.before(:each) {raise NonStandardError, "in before_each"}
      end

      it "should not run example block if before_each fails" do
        @proxy.run
        @example_ran.should == false
      end

      it "should run after_each block" do
        after_each_ran = false
        @behaviour.after(:each) {after_each_ran = true}
        @proxy.run
        after_each_ran.should == true
      end

      it "should report failure location when in before_each" do
        @reporter.should_receive(:example_finished) do |example_definition, error, location|
          example_definition.should equal(@example_definition)
          error.message.should eql("in before_each")
          location.should eql("before(:each)")
        end
        @proxy.run
      end
    end

    describe ExampleRunner, "#run where after_each fails" do
      it_should_behave_like "Spec::DSL::ExampleRunner#run"

      before do
        @example_ran = example_ran = false
        @example_definition = @behaviour.create_example_definition("should not run") do
          example_ran = true
        end
        @proxy = create_proxy(@example_definition)
        @behaviour.after(:each) { raise(NonStandardError.new("in after_each")) }
      end

      it "should report failure location when in after_each" do
        @reporter.should_receive(:example_finished) do |example_definition, error, location|
          example_definition.should equal(@example_definition)
          error.message.should eql("in after_each")
          location.should eql("after(:each)")
        end
        @proxy.run
      end
    end

    describe ExampleRunner, "#run with use cases" do
      predicate_matchers[:is_a] = [:is_a?]
      it_should_behave_like "Spec::DSL::ExampleRunner#run"

      it "should run example block in scope of example" do
        scope_object = nil
        @example_definition = @behaviour.create_example_definition("should pass") do
          self.instance_of?(ExampleDefinition).should == false
          scope_object = self
        end
        @proxy = create_proxy(@example_definition)
        @example = @proxy.example

        @reporter.should_receive(:example_finished).with(equal(@example_definition), nil, nil, false)
        @proxy.run
        
        scope_object.should == @example
        scope_object.should be_instance_of(@behaviour)
      end

      it "should accept an options hash following the example name" do
        example_definition_options = {:key => 'value'}
        example_definition = @behaviour.create_example_definition("name", example_definition_options)
        example_definition.options.should === example_definition_options
      end

      it "should report NO NAME when told to use generated description with --dry-run" do
        @options.dry_run = true
        example_definition = @behaviour.create_example_definition(:__generate_description) do
          5.should == 5
        end
        proxy = create_proxy(example_definition)

        @reporter.should_receive(:example_finished) do |example_definition, error, location|
          example_definition.description.should == "NO NAME (Because of --dry-run)"
          location.should == "NO NAME (Because of --dry-run)"
         end
        proxy.run
      end

      it "should report given name if present with --dry-run" do
        @options.dry_run = true
        example_definition = @behaviour.create_example_definition("example name") do
          5.should == 5
        end
        proxy = create_proxy(example_definition)

        @reporter.should_receive(:example_finished) do |example_definition, error, location|
          example_definition.description.should == "example name"
          location.should == "example name"
         end
        proxy.run
      end

      it "should report NO NAME when told to use generated description with no expectations" do
        example_definition = @behaviour.create_example_definition(:__generate_description) {}
        proxy = create_proxy(example_definition)
        @reporter.should_receive(:example_finished) do |example, error, location|
          example.description.should == "NO NAME (Because there were no expectations)"
        end
        proxy.run
      end

      it "should report NO NAME when told to use generated description and matcher fails" do
        example_definition = @behaviour.create_example_definition(:__generate_description) do
          5.should "" # Has no matches? method..
        end
        proxy = create_proxy(example_definition)

        @reporter.should_receive(:example_finished) do |example, error, location|
          example_definition.description.should == "NO NAME (Because of Error raised in matcher)"
          location.should == "NO NAME (Because of Error raised in matcher)"
        end
        proxy.run
      end

      it "should report generated description when told to and it is available" do
        example_definition = @behaviour.create_example_definition(:__generate_description) {
          5.should == 5
        }
        proxy = create_proxy(example_definition)
        
        @reporter.should_receive(:example_finished) do |example_definition, error, location|
          example_definition.description.should == "should == 5"
        end
        proxy.run
      end

      it "should unregister description_generated callback (lest a memory leak should build up)" do
        example_definition = @behaviour.create_example_definition("something")
        proxy = create_proxy(example_definition)

        Spec::Matchers.should_receive(:clear_generated_description)
        proxy.run
      end
    end
  end
end
