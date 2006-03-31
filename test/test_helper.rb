require 'test/unit'
$LOAD_PATH.push File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/../test'
require 'spec'
mock_context_runner = Spec::Api::Mock.new "mock_context_runner"
mock_context_runner.should_receive(:add_context).any_number_of_times
mock_context_runner.should_receive(:run).any_number_of_times
Spec::Runner::Context.context_runner = mock_context_runner
