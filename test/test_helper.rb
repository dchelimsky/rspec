require 'test/unit'
require 'stringio'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/../test'
require 'spec'
mock_context_runner = Spec::Api::Mock.new "mock_context_runner"
mock_context_runner.should. receive(:add_context).any.number.of.times
mock_context_runner.should.receive(:run).any.number.of.times
Spec::Runner::Context.context_runner = mock_context_runner
