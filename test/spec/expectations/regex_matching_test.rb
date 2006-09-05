require File.dirname(__FILE__) + '/../../test_helper'

module Spec
  module Expectations
    module Helper
      class ShouldMatchTest < Test::Unit::TestCase

        def test_should_not_raise_when_objects_match
          assert_nothing_raised do
            "hi aslak".should_match(/aslak/)
          end
        end

        def test_should_raise_when_objects_do_not_match
          assert_raise(ExpectationNotMetError) do
            "hi aslak".should_match(/steve/)
          end
        end
      end

      class ShouldNotMatchTest < Test::Unit::TestCase
        def test_should_not_raise_when_objects_do_not_match
          assert_nothing_raised do
            "hi aslak".should_not_match(/steve/)
          end
        end

        def test_should_raise_when_objects_match
          assert_raise(ExpectationNotMetError) do
            "hi aslak".should_not_match(/aslak/)
          end
        end
      end
    end
  end
end
