require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ShouldIncrementTest < Test::Unit::TestCase
        def test_should_pass_when_block_increments
          assert_nothing_raised do
            arr = []
            lambda { arr << "something" }.should.increment arr, :length
          end
        end

        def test_should_pass_when_block_increments_unsing_underscores
          assert_nothing_raised do
            arr = []
            lambda { arr << "something" }.should_increment arr, :length
          end
        end
  
        def test_should_fail_when_block_doesnt_increment
          assert_raise(ExpectationNotMetError) do
            arr = []
            lambda {}.should.increment arr, :length
          end
        end
      end

      class ShouldNotIncrementTest < Test::Unit::TestCase
        def test_should_pass_when_block_doesnt_increment
          assert_nothing_raised do
            arr = []
            lambda {}.should.not.increment arr, :length
          end
        end
  
        def test_should_fail_when_block_increments
          assert_raise(ExpectationNotMetError) do
            arr = []
            lambda {arr << "something" }.should.not.increment arr, :length
          end
        end
      end

      class ShouldDecrementTest < Test::Unit::TestCase
        def test_should_pass_when_block_decrements
          assert_nothing_raised do
            arr = ["something"]
            lambda { arr.pop }.should.decrement arr, :length
          end
        end
  
        def test_should_fail_when_block_doesnt_decrement
          assert_raise(ExpectationNotMetError) do
            arr = ["something"]
            lambda {}.should.decrement arr, :length
          end
        end
      end

      class ShouldNotDecrementTest < Test::Unit::TestCase
        def test_should_pass_when_block_doesnt_decrement
          assert_nothing_raised do
            arr = ["something"]
            lambda {}.should.not.decrement arr, :length
          end
        end
  
        def test_should_fail_when_block_decrements
          assert_raise(ExpectationNotMetError) do
            arr = ["something"]
            lambda { arr.pop }.should.not.decrement arr, :length
          end
        end
      end
    end
  end
end