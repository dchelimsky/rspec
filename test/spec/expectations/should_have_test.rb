require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper
      class ShouldHaveTest < Test::Unit::TestCase
        
        def setup
          @owner = CollectionOwner.new
          (1..3).each do |n|
            @owner.add_to_collection_with_length_method n
            @owner.add_to_collection_with_size_method n
          end
        end
        
        def test_should_raise_when_expecting_less_than_actual_length
          assert_raise(ExpectationNotMetError) do
            @owner.should_have(2).items_in_collection_with_length_method
          end
        end

        def test_should_raise_when_expecting_less_than_actual_length_with_exactly
          assert_raise(ExpectationNotMetError) do
            @owner.should_have_exactly(2).items_in_collection_with_length_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_length
          assert_raise(ExpectationNotMetError) do
            @owner.should_have(4).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_actual_length
          assert_nothing_raised do
            @owner.should_have(3).items_in_collection_with_length_method
            @owner.should_have_exactly(3).items_in_collection_with_length_method
          end
        end
        
        def test_should_raise_when_expecting_less_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should_have(2).items_in_collection_with_size_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should_have(4).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_actual_size
          assert_nothing_raised do
            @owner.should_have(3).items_in_collection_with_size_method
            @owner.should_have_exactly(3).items_in_collection_with_size_method
          end
        end
        
        def test_should_not_raise_when_expecting_actual_size_with_args
          assert_nothing_raised do
            @owner.should_have(3).items_for('a')
            @owner.should_have_exactly(3).items_for('a')
            @owner.should_have(1).items_for('b')
            @owner.should_have_exactly(1).items_for('b')
          end
        end
      end
      
      class ShouldHaveAtLeastTest < Test::Unit::TestCase
        
        def setup
          @owner = CollectionOwner.new
          (1..3).each do |n|
            @owner.add_to_collection_with_length_method n
            @owner.add_to_collection_with_size_method n
          end
        end
        
        def test_should_not_raise_when_expecting_less_than_actual_length
          assert_nothing_raised do
            @owner.should_have_at_least(2).items_in_collection_with_length_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_length
          assert_raise(ExpectationNotMetError) do
            @owner.should_have_at_least(4).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_actual_length
          assert_nothing_raised do
            @owner.should_have_at_least(3).items_in_collection_with_length_method
          end
        end

        
        def test_should_not_raise_when_expecting_less_than_actual_size
          assert_nothing_raised do
            @owner.should_have_at_least(2).items_in_collection_with_size_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should_have_at_least(4).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_actual_size
          assert_nothing_raised do
            @owner.should_have_at_least(3).items_in_collection_with_size_method
          end
        end
        
      end
      
      class ShouldHaveAtMostTest < Test::Unit::TestCase
        
        def setup
          @owner = CollectionOwner.new
          (1..3).each do |n|
            @owner.add_to_collection_with_length_method n
            @owner.add_to_collection_with_size_method n
          end
        end
        
        def test_should_raise_when_expecting_less_than_actual_length
          assert_raise(ExpectationNotMetError) do
            @owner.should_have_at_most(2).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_more_than_actual_length
          assert_nothing_raised do
            @owner.should_have_at_most(4).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_actual_length
          assert_nothing_raised do
            @owner.should_have_at_most(3).items_in_collection_with_length_method
          end
        end

        
        def test_should_raise_when_expecting_less_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should_have_at_most(2).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_more_than_actual_size
          assert_nothing_raised do
            @owner.should_have_at_most(4).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_actual_size
          assert_nothing_raised do
            @owner.should_have_at_most(3).items_in_collection_with_size_method
          end
        end
        
      end
    end
  end
end