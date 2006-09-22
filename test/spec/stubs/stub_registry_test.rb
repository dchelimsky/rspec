require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubRegistryTest < Test::Unit::TestCase
      def setup
        @space = StubSpace.new
        @target = Object.new
        @stub_method_name = :foobar
        @stub_method = @space.create_method(@target, @stub_method_name).with {}
        @registry = @space.registry
        @registry[@target, @stub_method_name] = @stub_method
      end

      def test_register__should_register_object_and_method
        assert_equal @stub_method, @registry[@target, @stub_method_name]
      end

      def test_invoke__with_no_block__should_send_only_arguments
        target = Object.new
        method_name = :foobar
        expected_args = [1, 2]
        block = nil
        passed_args = nil
        expected_return_value = :return_value
        stub_method = @space.create_method(target, method_name).with do |*args|
          passed_args = expected_args
          expected_return_value
        end
        return_value = @registry.invoke(target, method_name, expected_args, &block)
        assert_equal expected_return_value, return_value
        assert_equal expected_args, passed_args
      end

      def test_invoke__with_block__should_send_arguments_with_block
        target = Object.new
        method_name = :foobar
        args = [1, 2]
        block = proc {}
        passed_args = nil
        @space.create_method(target, method_name).with do |*args|
          passed_args = args
        end
        @registry.invoke(target, method_name, args, &block)
        assert_equal [1, 2, block], passed_args
      end

      def test_clear__should_remove_all_elements
        @registry.clear!
        assert_nil @registry[@target, @stub_method_name]
      end

      def test_clear__should_reset_all_stub_methods
        another_target = Object.new
        @registry[another_target, :baz] = @space.create_method(another_target, :baz).with {}
        @registry.clear!
        assert !@target.should_respond_to?(:foobar)
        assert !another_target.should_respond_to?(:baz)
      end
    end
  end
end
