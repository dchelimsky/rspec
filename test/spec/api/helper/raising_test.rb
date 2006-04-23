require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ShouldRaiseTest < Test::Unit::TestCase

        def test_should_raise_should_pass_when_proper_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistent_method }.should.raise NoMethodError
          end
        end
  
        def test_should_raise_should_fail_when_wrong_exception_is_raised
          begin
            proc { ''.nonexistent_method }.should.raise SyntaxError
          rescue => e
          end
          assert_match(/<Proc> should raise <SyntaxError> but raised #<NoMethodError: undefined method `nonexistent_method' for \"\":String>>/, e.inspect)
        end
  
        def test_should_raise_should_fail_when_no_exception_is_raised
          begin
            proc { }.should.raise SyntaxError
          rescue => e
          end
          assert_match(/<Proc> should raise <SyntaxError> but raised nothing>/, e.inspect)
        end
      end
        
      class ShouldNotRaiseTest < Test::Unit::TestCase
  
        def test_should_not_raise_should_pass_when_other_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistent_method }.should.not.raise SyntaxError
          end
        end
  
        def test_should_not_raise_should_pass_when_no_exception_is_raised
          assert_nothing_raised do
            proc { ''.to_s }.should.not.raise NoMethodError
          end
        end

        def test_should_not_raise_without_exception_should_pass_when_no_exception_is_raised
          assert_nothing_raised do
            proc { ''.to_s }.should.not.raise
          end
        end
        
        def test_should_not_raise_should_fail_when_specific_exception_is_raised
          begin
            proc { ''.nonexistent_method }.should.not.raise NoMethodError
          rescue => e
          end
          assert_match(/<Proc> should not raise <NoMethodError>/, e.inspect)
        end
  
        def test_should_include_actual_error_in_failure_message
          begin
            proc { ''.nonexistent_method }.should.not.raise Exception
          rescue => e
          end
          assert_match(/<Proc> should not raise <Exception> but raised #<NoMethodError: undefined method `nonexistent_method' for \"\":String>>/, e.inspect)
        end
  
        def TODOtest_should_understand_raised_with_message_matching
          lambda do
            raise 'Hello'
          end.should.raise(StandardError).with.message.matching /ello/
        end

      end
    end
  end
end
