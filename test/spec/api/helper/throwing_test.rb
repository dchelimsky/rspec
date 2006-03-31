require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ThrowingTest < Test::Unit::TestCase

        # should.raise
  
        def test_should_throw_should_pass_when_proper_symbol_is_thrown
          assert_nothing_raised do
            proc { throw :foo }.should.throw :foo
          end
        end
  
        def test_should_throw_should_fail_when_wrong_exception_is_thrown
          assert_raise(Spec::Api::ExpectationNotMetError) do
            proc { throw :bar }.should.throw :foo
          end
        end
   
        def test_should_throw_should_fail_when_no_symbol_is_thrown
          assert_raise(Spec::Api::ExpectationNotMetError) do
            proc {''.to_s}.should.throw :foo
          end
        end

        # should.not.throw

        def test_should_not_throw_should_fail_when_specific_symbol_is_thrown
          assert_raise(Spec::Api::ExpectationNotMetError) do
            proc { throw :foo }.should.not.throw :foo
          end
        end

        def test_should_not_throw_should_pass_when_other_symbol_is_thrown
          assert_nothing_raised do
            proc { throw :bar }.should.not.throw :foo
          end
        end

        def test_should_not_throw_should_pass_when_no_symbol_is_thrown
          assert_nothing_raised do
            proc { ''.to_s }.should.not.throw :foo
          end
        end

        def test_should_not_throw_should_pass_when_no_symbol_is_thrown_and_none_is_specified
          assert_nothing_raised do
            proc { ''.to_s }.should.not.throw
          end
        end
      end
    end
  end
end
