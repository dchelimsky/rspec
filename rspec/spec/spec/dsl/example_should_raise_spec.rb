require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module DSL
    describe ExampleRunner, " declared with {:should_raise => ...}" do
      before(:each) do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @reporter = ::Spec::Runner::Reporter.new(@options)
        @reporter.stub!(:example_started)
        @options.reporter = @reporter
        @behaviour = Class.new(Example).describe("My Behaviour")
      end
  
      def verify_error(error, message=nil)
        error.should be_an_instance_of(Spec::Expectations::ExpectationNotMetError)
        unless message.nil?
          return error.message.should =~ message if Regexp === message
          return error.message.should == message
        end
      end

      it "true} should pass when there is an ExpectationNotMetError" do
        example_definition = @behaviour.create_example_definition("example", :should_raise => true) do
          raise Spec::Expectations::ExpectationNotMetError
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          error.should be_nil
        end
        proxy.run
      end

      it "true} should fail if nothing is raised" do
        example_definition = @behaviour.create_example_definition("example", :should_raise => true) {}
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |example_name, error|
          verify_error(error, /example block expected Exception but nothing was raised/)
        end
        proxy.run
      end

      it "NameError} should pass when there is a NameError" do
        example_definition = @behaviour.create_example_definition("example", :should_raise => NameError) do
          raise NameError
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |example_name, error|
          error.should be_nil
        end
        proxy.run
      end

      it "NameError} should fail when there is no error" do
        example_definition = @behaviour.create_example_definition("example", :should_raise => NameError) do
          #do nothing
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |example_name, error|
          verify_error(error,/example block expected NameError but nothing was raised/)
        end
        proxy.run
      end

      it "NameError} should fail when there is the wrong error" do
        example_definition = @behaviour.create_example_definition("example", :should_raise => NameError) do
          raise RuntimeError
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |example_name, error|
          verify_error(error, /example block expected NameError but raised.+RuntimeError/)
        end
        proxy.run
      end

      it "[NameError]} should pass when there is a NameError" do
        example_definition = @behaviour.create_example_definition("spec", :should_raise => [NameError]) do
          raise NameError
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          error.should be_nil
        end
        proxy.run
      end

      it "[NameError]} should fail when there is no error" do
        example_definition = @behaviour.create_example_definition("spec", :should_raise => [NameError]) do
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          verify_error(error, /example block expected NameError but nothing was raised/)
        end
        proxy.run
      end

      it "[NameError]} should fail when there is the wrong error" do
        example_definition = @behaviour.create_example_definition("spec", :should_raise => [NameError]) do
          raise RuntimeError
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          verify_error(error, /example block expected NameError but raised.+RuntimeError/)
        end
        proxy.run
      end

      it "[NameError, 'message'} should pass when there is a NameError with the right message" do
        example_definition = @behaviour.create_example_definition("spec", :should_raise => [NameError, 'expected']) do
          raise NameError, 'expected'
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          error.should be_nil
        end
        proxy.run
      end

      it "[NameError, 'message'} should pass when there is a NameError with a message matching a regex" do
        example_definition = @behaviour.create_example_definition("spec", :should_raise => [NameError, /xpec/]) do
          raise NameError, 'expected'
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          error.should be_nil
        end
        proxy.run
      end

      it "[NameError, 'message'} should fail when there is a NameError with the wrong message" do
        example_definition = @behaviour.create_example_definition("spec", :should_raise => [NameError, 'expected']) do
          raise NameError, 'wrong message'
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          verify_error(error, /example block expected #<NameError: expected> but raised #<NameError: wrong message>/)
        end
        proxy.run
      end

      it "[NameError, 'message'} should fail when there is a NameError with a message not matching regexp" do
        example_definition = @behaviour.create_example_definition("spec", :should_raise => [NameError, /exp/]) do
          raise NameError, 'wrong message'
        end
        example = @behaviour.new(example_definition)
        proxy = ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |description, error|
          verify_error(error, /example block expected #<NameError: \(\?-mix:exp\)> but raised #<NameError: wrong message>/)
        end
        proxy.run
      end
    end
  end
end
