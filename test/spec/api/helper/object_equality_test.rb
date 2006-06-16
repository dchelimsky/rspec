require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ShouldEqualTest < Test::Unit::TestCase

        def test_should_not_raise_when_objects_are_equal
          assert_nothing_raised do
            'apple'.should.equal 'apple'
          end
        end
  
        def test_should_raise_when_objects_are_not_equal
          assert_raise(ExpectationNotMetError) do
            'apple'.should.equal 'orange'
          end
        end
        
        def test_should_raise_nice_message_when_objects_are_not_equal
          begin
            "apple".should_equal "grape"
          rescue ExpectationNotMetError => e
            assert_equal "\"apple\" should equal \"grape\"", e.message
          end
        end
      end

      class ShouldNotEqualTest < Test::Unit::TestCase

        def test_should_not_raise_when_objects_are_not_equal
          assert_nothing_raised do
            'apple'.should.not.equal 'orange'
          end
        end

        def test_should_not_equal_should_raise_when_objects_are_equal
          assert_raise(ExpectationNotMetError) do
            'apple'.should.not.equal 'apple'
          end
        end
      end

      class ShouldBeCloseTest < Test::Unit::TestCase
        def test_should_not_raise_when_values_are_within_bounds
          assert_nothing_raised do
            3.5.should.be.close 3.5, 0.5
            3.5.should.be.close 3.1, 0.5
            3.5.should.be.close 3.01, 0.5
            3.5.should.be.close 3.9, 0.5
            3.5.should.be.close 3.99, 0.5
          end
        end
        
        def test_should_raise_when_values_are_outside_bounds
          assert_raise(ExpectationNotMetError) do
            3.5.should.be.close 3.0, 0.5
          end
          assert_raise(ExpectationNotMetError) do
            3.5.should.be.close 2.0, 0.5
          end
          assert_raise(ExpectationNotMetError) do
            3.5.should.be.close 4.0, 0.5
          end
          assert_raise(ExpectationNotMetError) do
            3.5.should.be.close 5.0, 0.5
          end
        end

      end
    end
  end
end
