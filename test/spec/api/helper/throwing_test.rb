require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ShouldThrowTest < Test::Unit::TestCase

        def test_should_pass_when_proper_symbol_is_thrown
          assert_nothing_raised do
            lambda { throw :foo }.should_throw :foo
          end
        end
  
        def test_should_fail_when_wrong_symbol_is_thrown
          assert_raise(ExpectationNotMetError) do
            lambda { throw :bar }.should_throw :foo
          end
        end
   
        def test_should_fail_when_no_symbol_is_thrown
          assert_raise(ExpectationNotMetError) do
            lambda { ''.to_s }.should_throw :foo
          end
        end
      end

      class ShouldNotThrowTest < Test::Unit::TestCase

        def test_should_fail_when_expected_symbol_is_actually_thrown
          assert_raise(ExpectationNotMetError) do
            lambda { throw :foo }.should_not_throw :foo
          end
        end

        def test_should_pass_when_expected_symbol_is_thrown
          assert_nothing_raised do
            lambda { throw :bar }.should_not_throw :foo
          end
        end

        def test_should_pass_when_no_symbol_is_thrown
          assert_nothing_raised do
            lambda { ''.to_s }.should_not_throw :foo
          end
        end

        def test_should_pass_when_no_symbol_is_thrown_and_none_is_specified
          assert_nothing_raised do
            lambda { ''.to_s }.should_not_throw
          end
        end
      end
    end
  end
end
