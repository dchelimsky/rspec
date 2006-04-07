require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class EqualityTest < Test::Unit::TestCase

        def setup
          @dummy = 'dummy'
          @equal_dummy = 'dummy'
          @another_dummy  = 'another_dummy'
          @nil_var = nil
        end

        # should.equal
  
        def test_should_equal_should_not_raise_when_objects_are_equal
          assert_nothing_raised do
            @dummy.should.equal @equal_dummy
          end
        end
  
        def test_should_equal_should_raise_when_objects_are_not_equal
          assert_raise(ExpectationNotMetError) do
            @dummy.should.equal @another_dummy
          end
        end

        # should.not.equal

        def test_should_not_equal_should_not_raise_when_objects_are_not_equal
          assert_nothing_raised do
            @dummy.should.not.equal @another_dummy
          end
        end

        def test_should_not_equal_should_raise_when_objects_are_not_equal
          assert_raise(ExpectationNotMetError) do
            @dummy.should.not.equal @equal_dummy
          end
        end

        def test_should_be_close_good_cases
          assert_nothing_raised do
            3.5.should.be.close 3.5, 0.5
            3.5.should.be.close 3.1, 0.5
            3.5.should.be.close 3.01, 0.5
            3.5.should.be.close 3.9, 0.5
            3.5.should.be.close 3.99, 0.5
          end
        end
        
        def test_should_be_close_failing_cases
          assert_raise(ExpectationNotMetError) do
            3.5.should.be.close 3.0, 0.5
            3.5.should.be.close 2.0, 0.5
            3.5.should.be.close 4.0, 0.5
            3.5.should.be.close 5.0, 0.5
          end
        end

      end
    end
  end
end
