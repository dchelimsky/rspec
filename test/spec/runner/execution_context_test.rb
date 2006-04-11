require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ExecutionContextTest < Test::Unit::TestCase
      def test_should_add_new_mock_to_spec_when_mock_message_received
        spec = Api::Mock.new "spec"
        spec.should.receive(:add_mock) {|mock| mock.instance_of? Api::Mock}
        ec = ExecutionContext.new spec
        mock = ec.mock("a mock")
      end
      
      def test_violated
        assert_raise(Spec::Api::ExpectationNotMetError) do
          ExecutionContext.new(nil).violated
        end
      end
      
      def test_duck_type
        ec = ExecutionContext.new(Api::Mock.new("spec", :null_object => true))
        duck_type = ec.duck_type(:length)
        assert(duck_type.is_a? Api::DuckType)
        assert(duck_type.talks_like? [])
      end
    end
  end
end