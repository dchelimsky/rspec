require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Mocks
    context "calling :should_receive with an options hash" do
      specify "should report the file and line submitted with :expected_from" do
        spec = Spec::DSL:: Example.new "spec" do
          mock = Spec::Mocks::Mock.new("a mock")
          mock.should_receive(:message, :expected_from => "/path/to/blah.ext:37")
        end
        reporter = mock("reporter", :null_object => true)
        reporter.should_receive(:example_finished) do |spec, error|
          error.backtrace.detect {|line| line =~ /\/path\/to\/blah.ext:37/}.should_not be_nil
        end
        spec.run(reporter, nil, nil, nil, Object.new)
      end

      specify "should use the message supplied with :message" do
        spec = Spec::DSL:: Example.new "spec" do
          mock = Spec::Mocks::Mock.new("a mock")
          mock.should_receive(:message, :message => "recebi nada")
        end
        reporter = mock("reporter", :null_object => true)
        reporter.should_receive(:example_finished) do |spec, error|
          error.message.should == "recebi nada"
        end
        spec.run(reporter, nil, nil, nil, Object.new)
      end
    end
  end
end
