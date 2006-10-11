require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper
      class ContainmentTest < Test::Unit::TestCase

        def setup
          @dummy = 'dummy'
          @equal_dummy = 'dummy'
          @another_dummy  = 'another_dummy'
          @nil_var = nil
        end

        # should_include
  
        def test_should_include_shouldnt_raise_when_string_inclusion_is_present
          assert_nothing_raised do
            @dummy.should_include "mm"
          end
        end
  
        def test_should_include_should_raise_when_string_inclusion_is_missing
          assert_raise(ExpectationNotMetError) do
            @dummy.should_include "abc" 
          end
        end

        def test_should_include_shouldnt_raise_when_array_inclusion_is_present
          assert_nothing_raised do
            [1, 2, 3].should_include 2
          end
        end

        def test_should_include_should_raise_when_array_inclusion_is_missing
          assert_raise(ExpectationNotMetError) do
            [1, 2, 3].should_include 5
          end
        end

        def test_should_include_shouldnt_raise_when_hash_inclusion_is_present
          assert_nothing_raised do
            {"a"=>1}.should_include "a"
          end
        end

        def test_should_have_key_shouldnt_raise_when_hash_inclusion_is_present
          assert_nothing_raised do
            {"a"=>1}.should_have_key "a"
          end
        end

        def test_should_have_key_should_raise_when_hash_inclusion_is_not_present
          lambda {
            {"a"=>1}.should_have_key "b"
          }.should_raise ExpectationNotMetError, "<{\"a\"=>1}> should have key: [\"b\"]"
        end

        def test_should_include_should_raise_when_hash_inclusion_is_missing
          assert_raise(ExpectationNotMetError) do
            {"a"=>1}.should_include "b"
          end
        end

        def test_should_include_shouldnt_raise_when_enumerable_inclusion_is_present
          assert_nothing_raised do
            IO.constants.should_include "SEEK_SET"
          end
        end

        def test_should_include_should_raise_when_enumerable_inclusion_is_missing
          assert_raise(ExpectationNotMetError) do
            IO.constants.should_include "BLAH"
          end
        end
  
        # should_not_include
  
        def test_should_not_include_shouldnt_raise_when_string_inclusion_is_missing
          assert_nothing_raised do
            @dummy.should_not_include "abc"
          end
        end

        def test_should_not_include_should_raise_when_string_inclusion_is_present
          assert_raise(ExpectationNotMetError) do
            @dummy.should_not_include "mm"
          end
        end

        def test_should_not_include_shouldnt_raise_when_array_inclusion_is_missing
          assert_nothing_raised do
            [1, 2, 3].should_not_include 5
          end
        end

        def test_should_not_include_should_raise_when_array_inclusion_is_present
          assert_raise(ExpectationNotMetError) do
            [1, 2, 3].should_not_include 2
          end
        end

        def test_should_not_include_shouldnt_raise_when_hash_inclusion_is_missing
          assert_nothing_raised do
            {"a"=>1}.should_not_include "b"
          end
        end

        def test_should_not_include_should_raise_when_hash_inclusion_is_present
          assert_raise(ExpectationNotMetError) do
            {"a"=>1}.should_not_include "a"
          end
        end

        def test_should_not_include_shouldnt_raise_when_enumerable_inclusion_is_present
          assert_nothing_raised do
            IO.constants.should_not_include "BLAH"
          end
        end

        def test_should_not_include_should_raise_when_enumerable_inclusion_is_missing
          assert_raise(ExpectationNotMetError) do
            IO.constants.should_not_include "SEEK_SET" 
          end
        end
        
        def test_should_not_have_key_shouldnt_raise_when_hash_inclusion_is_present
          assert_nothing_raised do
            {"a"=>1}.should_not_have_key "b"
          end
        end

        def test_should_have_key_should_raise_when_hash_inclusion_is_not_present
          lambda {
            {"a"=>1}.should_not_have_key "a"
          }.should_raise ExpectationNotMetError, "<{\"a\"=>1}> should not have key: [\"a\"]"
        end

      end
    end
  end
end