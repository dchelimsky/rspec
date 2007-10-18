require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe StepMatchers do
      it "should not find a matcher if empty" do
        step_matchers = StepMatchers.new
        step_matchers.find(:given, "this and that").should be_nil
      end
      
      it "should find a simple matcher if present" do
        step_matchers = StepMatchers.new
        step_matcher = step_matchers.create_matcher(:given, "this and that") {}
        step_matchers.find(:given, "this and that").should equal(step_matcher)
      end
    end
  end
end
