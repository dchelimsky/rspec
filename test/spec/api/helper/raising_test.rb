require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class RaisingTest < Test::Unit::TestCase

        # should.raise
  
        def test_should_raise_should_pass_when_proper_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistant_method }.should.raise NoMethodError
          end
        end
  
        def test_should_raise_should_fail_when_wrong_exception_is_raised
          assert_raise(ExpectationNotMetError) do
            proc { ''.nonexistant_method }.should.raise SyntaxError
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
            proc { ''.nonexistant_method }.should.not.raise NoMethodError
          end
        end
  
        def test_should_not_raise_should_pass_when_other_exception_is_raised
          assert_nothing_raised do
            proc { ''.nonexistant_method }.should.not.raise SyntaxError
          end
        end
  
        def test_should_not_raise_should_pass_when_no_exception_is_raised
          assert_nothing_raised do
            proc { ''.to_s }.should.not.raise NoMethodError
          end
        end
      end
    end
  end
end
