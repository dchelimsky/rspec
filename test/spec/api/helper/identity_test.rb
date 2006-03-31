require File.dirname(__FILE__) + '/../../../test_helper'

module Spec
  module Api
    module Helper
      class IdentityTest < Test::Unit::TestCase

        def setup
          @dummy = 'dummy'
          @equal_dummy = 'dummy'
          @another_dummy  = 'another_dummy'
          @nil_var = nil
        end

        def test_should_be_same_as_should_not_raise_when_objects_are_same
          assert_nothing_raised do
            @dummy.should.be @dummy
          end
        end

        def test_should_be_same_as_should_raise_when_objects_are_not_same
          assert_raise(Spec::Api::ExpectationNotMetError) do
            @dummy.should.be @equal_dummy
          end
        end

        def test_should_be_nil_should_not_raise_when_object_is_nil
          assert_nothing_raised do
            @nil_var.should.be nil
          end  
        end

        def test_should_be_nil_should_raise_when_object_is_not_nil
          assert_raise(Spec::Api::ExpectationNotMetError) do
            @dummy.should.be nil
          end
        end

        # should.not.be

        def test_should_not_be_same_as_should_not_raise_when_objects_are_not_same
          assert_nothing_raised do
            @dummy.should.not.be @equal_dummy
          end
        end

        def test_should_not_be_same_as_should_raise_when_objects_are_not_same
          assert_raise(Spec::Api::ExpectationNotMetError) do
            @dummy.should.not.be @dummy
          end
        end

        def test_should_not_be_nil_should_not_raise_when_object_is_not_nil
          assert_nothing_raised do
            @dummy.should.not.be nil
          end  
        end

        def test_should_not_be_nil_should_raise_when_object_is_nil
          assert_raise(Spec::Api::ExpectationNotMetError) do
            @nil_var.should.not.be nil
          end
        end

      end
    end
  end
end
