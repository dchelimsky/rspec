require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper
      class ShouldRaiseTest < Test::Unit::TestCase

        def test_should_pass_when_exact_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistent_method }.should_raise NoMethodError
          end
        end
  
        def test_should_pass_when_exact_exception_is_raised_with_message
          assert_nothing_raised do
            lambda { raise StandardError.new("this is standard") }.should_raise StandardError, "this is standard"
          end
        end
  
        def test_should_fail_when_exact_exception_is_raised_with_wrong_message
          assert_raises(Spec::Expectations::ExpectationNotMetError) do
            lambda { raise StandardError.new("chunky bacon") }.should_raise StandardError, "rotten tomatoes"
          end
        end
  
        def test_should_pass_when_subclass_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistent_method }.should_raise
          end
        end
  
        def test_should_fail_when_wrong_exception_is_raised
          begin
            proc { ''.nonexistent_method }.should_raise SyntaxError
          rescue => e
          end
          assert_equal("<Proc> should raise <SyntaxError> but raised #<NoMethodError: undefined method `nonexistent_method' for \"\":String>", e.message)
        end
  
        def test_should_fail_when_no_exception_is_raised
          begin
            proc { }.should_raise SyntaxError
          rescue => e
          end
          assert_equal("<Proc> should raise <SyntaxError> but raised nothing", e.message)
        end
      end
        
      class ShouldNotRaiseTest < Test::Unit::TestCase
  
        def test_should_pass_when_exact_exception_is_raised_with_wrong_message
          assert_nothing_raised do
            lambda { raise StandardError.new("abc") }.should_not_raise StandardError, "xyz"
          end
        end
  
        def test_should_faile_when_exact_exception_is_raised_with_message
          assert_raises(Spec::Expectations::ExpectationNotMetError) do
            lambda { raise StandardError.new("abc") }.should_not_raise StandardError, "abc"
          end
        end
  
        def test_should_pass_when_other_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistent_method }.should_not_raise SyntaxError
          end
        end
  
        def test_should_pass_when_no_exception_is_raised
          assert_nothing_raised do
            proc { ''.to_s }.should_not_raise NoMethodError
          end
        end

        def test_without_exception_should_pass_when_no_exception_is_raised
          assert_nothing_raised do
            proc { ''.to_s }.should_not_raise
          end
        end
        
        def test_should_fail_when_specific_exception_is_raised
          begin
            proc { ''.nonexistent_method }.should_not_raise NoMethodError
          rescue => e
          end
          assert_equal("<Proc> should not raise <NoMethodError>", e.message)
        end
  
        def test_should_include_actual_error_in_failure_message
          begin
            proc { ''.nonexistent_method }.should_not_raise Exception
          rescue => e
          end
          assert_equal("<Proc> should not raise <Exception> but raised #<NoMethodError: undefined method `nonexistent_method' for \"\":String>", e.message)
        end

      end
    end
  end
end
