require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module MethodProxy
    class MethodProxySpaceTest < Test::Unit::TestCase
      def setup
        @space = MethodProxySpace.new
      end

      def test_clear__should_clear_all_stubbed_objects
        mock_target1 = Spec::Mocks::Mock.new("target1")
        @space.create_proxy(mock_target1, :foo, proc {})
        mock_target2 = Spec::Mocks::Mock.new("target2")
        @space.create_proxy(mock_target2, :foo, proc {})

        mock_target1.should_receive(:reset_proxied_methods!).once
        mock_target2.should_receive(:reset_proxied_methods!).once
        @space.clear!
        mock_target1.__verify
        mock_target2.__verify
      end
    end
  end
end