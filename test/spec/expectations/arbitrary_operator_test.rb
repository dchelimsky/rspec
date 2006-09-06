require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper

      class ArbitraryOperatorTest < Test::Unit::TestCase

        # == arg
  
        def test_should_pass_when_equals_operator_passes
          assert_nothing_raised do
            (2+2).should == 4
          end
        end
        
        def test_should_fail_when_equals_operator_fails
          assert_raise(ExpectationNotMetError) do
            (2+2).should == 5
          end
        end

        # =~ arg
  
        def test_should_pass_when_match_operator_passes
          assert_nothing_raised do
            "foo".should =~ /oo/
          end
        end

        def test_should_fail_when_match_operator_fails
          assert_raise(ExpectationNotMetError) do
            "fu".should =~ /oo/
          end
        end

        # < and >
  
        def test_should_pass_when_comparison_passes
          assert_nothing_raised do
            3.should_be < 4
          end
        end

        def test_should_fail_when_comparison_fails
          assert_raise(ExpectationNotMetError) do
            3.should_be > 4
          end
        end

      end
      
    end
  end
end
