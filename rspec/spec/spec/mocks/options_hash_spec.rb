require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    describe "calling :should_receive with an options hash" do
      before do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @reporter = ::Spec::Runner::Reporter.new(@options)
        @behaviour = Class.new(::Spec::DSL::ExampleGroup).describe("Some Examples")
      end

      it "should report the file and line submitted with :expected_from" do
        example_definition = @behaviour.create_example "spec" do
          mock = Spec::Mocks::Mock.new("a mock")
          mock.should_receive(:message, :expected_from => "/path/to/blah.ext:37")
          mock.rspec_verify
        end
        example = @behaviour.new(example_definition)
        proxy = ::Spec::DSL::ExampleRunner.new(@options, example)
        
        @reporter.should_receive(:example_finished) do |spec, error|
          error.backtrace.detect {|line| line =~ /\/path\/to\/blah.ext:37/}.should_not be_nil
        end
        proxy.run
      end

      it "should use the message supplied with :message" do
        example_definition = @behaviour.create_example "spec" do
          mock = Spec::Mocks::Mock.new("a mock")
          mock.should_receive(:message, :message => "recebi nada")
          mock.rspec_verify
        end
        example = @behaviour.new(example_definition)
        proxy = ::Spec::DSL::ExampleRunner.new(@options, example)
        @reporter.should_receive(:example_finished) do |spec, error|
          error.message.should == "recebi nada"
        end
        proxy.run
      end
    end
  end
end
