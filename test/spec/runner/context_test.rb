require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextTest < Test::Unit::TestCase
      
      def setup
        @listener = Api::Mock.new "listener"
        @context = Context.new("context") {}
      end
      
      def test_should_add_itself_to_listener_on_run
        @listener.should.receive(:add_context).with "context", :anything
        @context.run(@listener)
        @listener.__verify
      end
      
      def test_should_add_itself_to_listener_on_run_docs
        @listener.should.receive(:add_context).with "context"
        @context.run_docs(@listener)
        @listener.__verify
      end

    end
  end
end