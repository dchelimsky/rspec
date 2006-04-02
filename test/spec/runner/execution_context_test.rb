require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class ExecutionContextTest < Test::Unit::TestCase
      def test_should_add_new_mock_to_spec_when_mock_message_received
        spec = Api::Mock.new "spec"
        spec.should_receive(:add_mock) {|mock| mock.should.be.instance.of Api::Mock}
        ec = ExecutionContext.new spec
        mock = ec.mock("a mock")
      end
    end
  end
end