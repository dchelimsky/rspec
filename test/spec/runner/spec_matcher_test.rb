require File.dirname(__FILE__) + '/../../test_helper'
module Spec
  module Runner
    class SpecMatcherTest < Test::Unit::TestCase
      
      def test_should_match_context_and_spec
        matcher = SpecMatcher.new("a context with a spec", "a context")
        assert matcher.matches?("with a spec")
      end
      
      def test_should_not_match_wrong_context
        matcher = SpecMatcher.new("another context with a spec", "a context")
        assert !matcher.matches?("with a spec")
      end
     
      def test_should_not_match_wrong_spec
        matcher = SpecMatcher.new("a context with another spec", "a context")
        assert !matcher.matches?("with a spec")
      end
      
      def test_should_match_context_only
        matcher = SpecMatcher.new("a context", "a context")
        assert matcher.matches?("with a spec")
      end
      
      def test_should_not_match_wrong_context_only
        matcher = SpecMatcher.new("another context", "a context")
        assert !matcher.matches?("with a spec")
      end
      
      def test_should_match_spec_only
        matcher = SpecMatcher.new("with a spec", "a context")
        assert matcher.matches?("with a spec")
      end
      
      def test_should_match_wrong_spec_only
        matcher = SpecMatcher.new("with another spec", "a context")
        assert !matcher.matches?("with a spec")
      end
    end
  end
end
