require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Runner
    class ContextTest < Test::Unit::TestCase
      
      def setup
        @listener = Api::Mock.new "listener"
        @context = Context.new("context") {}
      end
      
      def test_should_add_itself_to_listener_on_run
        @listener.should_receive(:add_context).with "context"
        @context.run(@listener)
        @listener.__verify
      end
      
      def test_should_add_itself_to_listener_on_run_docs
        @listener.should_receive(:add_context).with "context"
        @context.run_docs(@listener)
        @listener.__verify
      end
      
      def test_should_execute_setup_from_inherited_context
      end

    end
  end
end