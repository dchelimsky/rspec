require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubTest < Test::Unit::TestCase
      def test_stub__should_create_stub_method
        object = Object.new
        assert_kind_of StubMethod, object.stub!(:foobar)
      end
    end
  end
end

