require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper
      class ShouldSatisfyTest < Test::Unit::TestCase

        def test_should_raise_exception_when_block_yields_false
          assert_raise(ExpectationNotMetError) do
            5.should_satisfy {|target| false }
          end
        end
  
        def test_should_not_raise_exception_when_block_yields_true
          assert_nothing_raised do
            5.should_satisfy {|target| true }
          end
        end

        # should_not_satisfy
  
        def test_should_raise_exception_when_block_yields_false_again
          assert_raise(ExpectationNotMetError) do
            5.should_not_satisfy {|target| true }
          end
        end
  
        def test_should_not_raise_exception_when_block_yields_true_again
          assert_nothing_raised do
            5.should_not_satisfy {|target| false }
          end
        end

      end
    end
  end
end
