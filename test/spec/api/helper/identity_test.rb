require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class ShouldBeTest < Test::Unit::TestCase

        def setup
          @dummy = 'dummy'
          @equal_dummy = 'dummy'
          @another_dummy  = 'another_dummy'
          @nil_var = nil
        end

        def test_should_not_raise_when_objects_are_same
          assert_nothing_raised do
            @dummy.should.be @dummy
          end
        end

        def test_should_raise_when_objects_are_not_same
          assert_raise(ExpectationNotMetError) do
            @dummy.should.be @equal_dummy
          end
        end

        def test_should_not_raise_when_both_objects_are_nil
          assert_nothing_raised do
            @nil_var.should.be nil
          end  
        end

        def test_should_raise_when_object_is_not_nil
          assert_raise(ExpectationNotMetError) do
            @dummy.should.be nil
          end
        end
      end

      class ShouldNotBeTest < Test::Unit::TestCase
        def setup
          @dummy = 'dummy'
          @equal_dummy = 'dummy'
          @another_dummy  = 'another_dummy'
          @nil_var = nil
        end

        def test_should_not_raise_when_objects_are_not_same
          assert_nothing_raised do
            @dummy.should.not.be @equal_dummy
          end
        end

        def test_should_raise_when_objects_are_same
          assert_raise(ExpectationNotMetError) do
            @dummy.should.not.be @dummy
          end
        end

        def test_should_not_raise_when_left_is_not_nil_and_right_is_nil
          assert_nothing_raised do
            @dummy.should.not.be nil
          end  
        end

        def test_should_raise_when_both_objects_are_nil
          assert_raise(ExpectationNotMetError) do
            @nil_var.should.not.be nil
          end
        end

      end
    end
  end
end
