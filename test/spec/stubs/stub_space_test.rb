require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubSpaceTest < Test::Unit::TestCase
      def setup
        @space = StubSpace.new
      end

      def test_create_registry
        registry = @space.create_registry
        assert_kind_of StubRegistry, registry
        assert_equal @space, registry.instance_eval {@space}
      end

      def test_create_stub
        target = Object.new
        name = "foobar"
        stub = @space.create_stub(target, name)
        assert_kind_of Stub, stub
        assert_equal @space, stub.instance_eval {@space}
        assert_equal target, stub.__target
        assert_equal name, stub.__name
      end

      def test_create_method
        target = Object.new
        method_name = :foobar
        method = @space.create_method(target, method_name)
        assert_kind_of StubMethod, method
        assert_equal @space, method.instance_eval {@space}
        assert_equal target, method.instance_eval {@target}
        assert_equal method_name, method.instance_eval {@method_name}
      end
    end
  end
end
require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubSpaceTest < Test::Unit::TestCase
      def setup
        @space = StubSpace.new
      end

      def test_create_registry
        registry = @space.create_registry
        assert_kind_of StubRegistry, registry
        assert_equal @space, registry.instance_eval {@space}
      end

      def test_create_stub
        target = Object.new
        name = "foobar"
        stub = @space.create_stub(target, name)
        assert_kind_of Stub, stub
        assert_equal @space, stub.instance_eval {@space}
        assert_equal target, stub.__target
        assert_equal name, stub.__name
      end

      def test_create_method
        target = Object.new
        method_name = :foobar
        method = @space.create_method(target, method_name)
        assert_kind_of StubMethod, method
        assert_equal @space, method.instance_eval {@space}
        assert_equal target, method.instance_eval {@target}
        assert_equal method_name, method.instance_eval {@method_name}
      end
    end
  end
end