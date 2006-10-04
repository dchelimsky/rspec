require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module MethodProxy
    class MethodProxyTest < Test::Unit::TestCase
      def setup
        @space = MethodProxySpace.new
        @target = Object.new
      end

      def test_call__with_no_block__should_send_only_arguments
        args_submitted = [1, 2]
        args_received = nil
        block = nil
        implementation = lambda do |*args|
          args_received = args
          :expected_return_value
        end
        proxy = @space.create_proxy(@target, :foo, implementation)
        assert_equal :expected_return_value, proxy.call(*args_submitted, &block)
        assert_equal args_submitted, args_received
      end

      def test_call__with_block__should_send_arguments_with_block
        args_submitted = [1, 2]
        args_received = nil
        block = proc {}
        implementation = lambda do |*args|
          args_received = args
          :expected_return_value
        end
        proxy = @space.create_proxy(@target, :foo, implementation)
        assert_equal :expected_return_value, proxy.call(*args_submitted, &block)
        assert_equal (args_submitted << block), args_received
      end

      def test_reset_proxied_methods__when_method_did_not_already_exist__should_remove_it
        object = Object.new
        object.stub!(:foobar).and_return(:return_value)
        object.reset_proxied_methods!
        assert !object.respond_to?(:foobar)
      end

      def test_reset_proxied_methods__when_method_already_exists__should_revert_to_original
        object = Object.new
        class << object
          def foobar
            :original_value
          end
        end
        object.stub!(:foobar).and_return(:return_value)
        object.reset_proxied_methods!
        assert :original_value, object.foobar
      end

      def test_reset_proxied_methods_at_class_level__when_method_already_exists__should_revert_to_original
        klass = Class.new
        class << klass
          def foobar
            :original_value
          end
        end
        klass.stub!(:foobar).and_return(:return_value)
        klass.reset_proxied_methods!
        assert :original_value, klass.foobar
      end

      def test_reset_proxied_methods__when_method_already_exists_in_base_class_should_revert_to_original_again
        klass = Class.new
        sub_klass = Class.new(klass)
        class << klass
          def foobar
            :original_value
          end
        end
        sub_klass.stub!(:foobar).and_return(:return_value)
        sub_klass.reset_proxied_methods!
        assert :original_value, sub_klass.foobar
      end

      def test_reset_proxied_methods__should_remove_saved_method_proxies
        object = Object.new
        class << object
          public :__method_proxy_space
        end
        object.stub!(:foobar).and_return(:return_value)
        assert_equal 1, object.__method_proxy_space.proxied_methods.length
        object.reset_proxied_methods!
        assert_equal 0, object.__method_proxy_space.proxied_methods.length
      end

      def test_reset_proxied_methods__should_notify_listeners
        object = Object.new
        class << object
          public :__on_reset_proxied_methods
        end

        listener_notified = false
        object.__on_reset_proxied_methods do
          listener_notified = true
        end

        object.reset_proxied_methods!
        listener_notified.should_equal true
      end
    end
  end
end