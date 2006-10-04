require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Stubs
    class StubMethodTest < Test::Unit::TestCase
      def setup
        @target = Object.new
        @stub_method = StubMethod.new(@target, :foobar)
      end

      def test_with__when_block_passed__should_define_method_with_the_block
        expected_value = Object.new
        @stub_method.and_return {expected_value}
        assert_equal expected_value, @target.foobar
      end

      def test_with__when_block_passed_taking_one_argument__should_define_method_with_the_block
        passed_value = nil
        @stub_method.and_return {|value| passed_value = value}
        expected_value = Object.new
        @target.foobar expected_value
        assert_equal expected_value, passed_value
      end

      def test_with__when_method_is_passed_a_block__should_accept_block_as_argument
        @stub_method.and_return {|block| block.call}
        passed_value = nil
        expected_value = Object.new
        @target.foobar {passed_value = expected_value}
        assert_equal expected_value, passed_value
      end

      def test_with__when_value_is_passed__should_return_value
        expected_value = Object.new
        @stub_method.and_return expected_value
        assert_equal expected_value, @target.foobar
      end

      def test_with__when_argument_and_block_are_passed__block_wins
        argument_value = Object.new
        block_value = Object.new
        @stub_method.and_return(argument_value) {block_value}
        assert_equal block_value, @target.foobar
      end
    end
  end
end
