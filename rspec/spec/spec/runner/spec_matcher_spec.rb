require File.dirname(__FILE__) + '/../../spec_helper.rb'

module Spec
  module Runner
    context "SpecMatcher" do
      
      specify "should match context and spec" do
        matcher=SpecMatcher.new("a context with a spec", "a context")
        matcher.matches?("with a spec").should_be(true)
      end
      
      specify "should match context only" do
        matcher=SpecMatcher.new("a context", "a context")
        matcher.matches?("with a spec").should_be(true)
      end
      
      specify "should match spec only" do
        matcher=SpecMatcher.new("with a spec", "a context")
        matcher.matches?("with a spec").should_be(true)
      end
      
      specify "should match with regexp reserved characters" do
        matcher=SpecMatcher.new("a context with #[] a spec", "a context")
        matcher.matches?("with #[] a spec").should_be(true)
      end
      
      specify "should match wrong spec only" do
        matcher=SpecMatcher.new("with another spec", "a context")
        (not matcher.matches?("with a spec")).should_be(true)
      end
      
      specify "should not match wrong context" do
        matcher=SpecMatcher.new("another context with a spec", "a context")
        (not matcher.matches?("with a spec")).should_be(true)
      end
      
      specify "should not match wrong context only" do
        matcher=SpecMatcher.new("another context", "a context")
        (not matcher.matches?("with a spec")).should_be(true)
      end
      
      specify "should not match wrong spec" do
        matcher=SpecMatcher.new("a context with another spec", "a context")
        (not matcher.matches?("with a spec")).should_be(true)
      end
      
    end
  end
end