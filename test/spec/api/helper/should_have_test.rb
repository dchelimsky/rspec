require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
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
            @owner.should.have(2).items_in_collection_with_length_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_length
          assert_raise(ExpectationNotMetError) do
            @owner.should.have(4).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_actual_length
          assert_nothing_raised do
            @owner.should.have(3).items_in_collection_with_length_method
          end
        end

        
        def test_should_raise_when_expecting_less_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should.have(2).items_in_collection_with_size_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should.have(4).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_actual_size
          assert_nothing_raised do
            @owner.should.have(3).items_in_collection_with_size_method
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
            @owner.should.have.at.least(2).items_in_collection_with_length_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_length
          assert_raise(ExpectationNotMetError) do
            @owner.should.have.at.least(4).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_actual_length
          assert_nothing_raised do
            @owner.should.have.at.least(3).items_in_collection_with_length_method
          end
        end

        
        def test_should_not_raise_when_expecting_less_than_actual_size
          assert_nothing_raised do
            @owner.should.have.at.least(2).items_in_collection_with_size_method
          end
        end

        def test_should_raise_when_expecting_more_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should.have.at.least(4).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_actual_size
          assert_nothing_raised do
            @owner.should.have.at.least(3).items_in_collection_with_size_method
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
            @owner.should.have.at.most(2).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_more_than_actual_length
          assert_nothing_raised do
            @owner.should.have.at.most(4).items_in_collection_with_length_method
          end
        end

        def test_should_not_raise_when_expecting_actual_length
          assert_nothing_raised do
            @owner.should.have.at.most(3).items_in_collection_with_length_method
          end
        end

        
        def test_should_raise_when_expecting_less_than_actual_size
          assert_raise(ExpectationNotMetError) do
            @owner.should.have.at.most(2).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_more_than_actual_size
          assert_nothing_raised do
            @owner.should.have.at.most(4).items_in_collection_with_size_method
          end
        end

        def test_should_not_raise_when_expecting_actual_size
          assert_nothing_raised do
            @owner.should.have.at.most(3).items_in_collection_with_size_method
          end
        end
        
      end
      
      class CollectionWithSizeMethod
        def initialize; @list = []; end
        def size; @list.size; end
        def push(item); @list.push(item); end
      end

      class CollectionWithLengthMethod
        def initialize; @list = []; end
        def length; @list.size; end
        def push(item); @list.push(item); end
      end

      class CollectionOwner
        attr_reader :items_in_collection_with_size_method, :items_in_collection_with_length_method

        def initialize
          @items_in_collection_with_size_method = CollectionWithSizeMethod.new
          @items_in_collection_with_length_method = CollectionWithLengthMethod.new
        end

        def add_to_collection_with_size_method(item)
          @items_in_collection_with_size_method.push(item)
        end

        def add_to_collection_with_length_method(item)
          @items_in_collection_with_length_method.push(item)
        end
      end
      
    end
  end
end