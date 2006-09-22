require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubMethodTest < Test::Unit::TestCase
      def setup
        @target = Object.new
        @stub_space = StubSpace.new
        @stub_method_name = :foobar
        @stub_method = @stub_space.create_method(@target, @stub_method_name)
      end

      def test_with__when_block_passed__should_define_method_with_the_block
        expected_value = Object.new
        @stub_method.with {expected_value}
        assert_equal expected_value, @target.foobar
      end

      def test_with__when_block_passed_taking_one_argument__should_define_method_with_the_block
        passed_value = nil
        @stub_method.with {|value| passed_value = value}
        expected_value = Object.new
        @target.foobar expected_value
        assert_equal expected_value, passed_value
      end

      def test_with__when_method_is_passed_a_block__should_accept_block_as_argument
        @stub_method.with {|block| block.call}
        passed_value = nil
        expected_value = Object.new
        @target.foobar {passed_value = expected_value}
        assert_equal expected_value, passed_value
      end

      def test_with__when_value_is_passed__should_return_value
        expected_value = Object.new
        @stub_method.with expected_value
        assert_equal expected_value, @target.foobar
      end

      def test_with__when_argument_and_block_are_passed__block_wins
        argument_value = Object.new
        block_value = Object.new
        @stub_method.with(argument_value) {block_value}
        assert_equal block_value, @target.foobar
      end

      def test_with__should_guard_against_stub_being_set_multiple_times
        @stub_method.with(nil)
        assert_raises(RuntimeError, "Stub has already been set") do
          @stub_method.with(nil)
        end
      end

      def test_reset__with_no_stub_method_set__should_keep_original_implementation
        def @target.foobar
          :original_foobar
        end
        stub_method = @stub_space.create_method(@target, :foobar)
        stub_method.reset!
        assert_equal :original_foobar, @target.foobar
      end

      def test_reset__when_method_overridden__should_return_back_to_original_implementation
        def @target.foobar
          :original_foobar
        end
        stub_method = @stub_space.create_method(@target, :foobar).with do
          :new_foobar
        end
        stub_method.reset!
        assert_equal :original_foobar, @target.foobar
      end

      def test_reset__when_new_method__should_remove_method
        @stub_method.with(nil)
        assert @target.respond_to?(@stub_method_name)
        @stub_method.reset!
        assert !@target.respond_to?(@stub_method_name)
      end

      def test_call__should_call_stub_method
        passed_argument = nil
        method_instance = proc do |arg|
          passed_argument=arg
          :foobar
        end
        @stub_method.instance_eval {@method_instance = method_instance}
        expected_argument = Object.new
        return_value = @stub_method.call expected_argument
        assert_equal :foobar, return_value
        assert_equal expected_argument, passed_argument
      end
    end
  end
end
