require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubTest < Test::Unit::TestCase
      def setup
        @space = StubSpace.new
        @target = Object.new
        @stub = @space.create_stub(@target, "foobar")
      end

      def test_initialize__should_have_target_and_name
        assert_equal @target, @stub.__target
        assert_equal "foobar", @stub.__name
      end

      def test_method__should_stub_method_on_the_target_object_when_block_passed
        expected_value = Object.new
        @stub.method(:foobar) {expected_value}
        assert_equal expected_value, @target.foobar
      end

      def test_method__when_no_block_passed__should_return_stub_method_class
        expected_value = Object.new
        stub_method = @stub.method(:foobar)
        assert_instance_of StubMethod, stub_method
        assert_equal @target, stub_method.instance_eval {@target}
        assert_equal :foobar, stub_method.instance_eval {@method_name}
      end
    end
  end
end
require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubTest < Test::Unit::TestCase
      def setup
        @space = StubSpace.new
        @target = Object.new
        @stub = @space.create_stub(@target, "foobar")
      end

      def test_initialize__should_have_target_and_name
        assert_equal @target, @stub.__target
        assert_equal "foobar", @stub.__name
      end

      def test_method__should_stub_method_on_the_target_object_when_block_passed
        expected_value = Object.new
        @stub.method(:foobar) {expected_value}
        assert_equal expected_value, @target.foobar
      end

      def test_method__when_no_block_passed__should_return_stub_method_class
        expected_value = Object.new
        stub_method = @stub.method(:foobar)
        assert_instance_of StubMethod, stub_method
        assert_equal @target, stub_method.instance_eval {@target}
        assert_equal :foobar, stub_method.instance_eval {@method_name}
      end
    end
  end
end