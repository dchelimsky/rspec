require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class RaisingTest < Test::Unit::TestCase

        # should.raise
  
        def test_should_raise_should_pass_when_proper_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistent_method }.should.raise NoMethodError
          end
        end
  
        def test_should_raise_should_fail_when_wrong_exception_is_raised
          assert_raise(ExpectationNotMetError) do
            proc { ''.nonexistent_method }.should.raise SyntaxError
          end
        end
  
        def test_should_raise_should_fail_when_no_exception_is_raised
          assert_raise(ExpectationNotMetError) do
            proc {''.to_s}.should.raise NoMethodError
          end
        end
        
        # should.not.raise
  
        def test_should_not_raise_should_fail_when_specific_exception_is_raised
          assert_raise(ExpectationNotMetError) do
            proc { ''.nonexistent_method }.should.not.raise NoMethodError
          end
        end
  
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
        
        def TODOtest_should_understand_raised_with_message_matching
          lambda do
            raise 'Hello'
          end.should.raise(StandardError).with.message.matching /ello/
        end

        def test_should_include_actual_error_in_failure_message
          begin
            proc { ''.nonexistent_method }.should.not.raise Exception
          rescue => e
            caught = true
            assert_match(/NoMethodError/, e.inspect)
          end
          assert caught
        end
  
      end
    end
  end
end
