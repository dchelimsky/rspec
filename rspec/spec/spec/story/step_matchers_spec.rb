require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe StepMatchers do
      before(:each) do
        @step_matchers = StepMatchers.new
      end
      
      it "should not find a matcher if empty" do
        @step_matchers.find(:given, "this and that").should be_nil
      end
      
      it "should create a given matcher" do
        step_matcher = @step_matchers.given("this and that") {}
        @step_matchers.find(:given, "this and that").should equal(step_matcher)
      end
      
      it "should create a when matcher" do
        step_matcher = @step_matchers.when("this and that") {}
        @step_matchers.find(:when, "this and that").should equal(step_matcher)
      end
      
      it "should create a them matcher" do
        step_matcher = @step_matchers.then("this and that") {}
        @step_matchers.find(:then, "this and that").should equal(step_matcher)
      end
      
      it "should add a matcher object" do
        step_matcher = StepMatcher.new("this and that") {}
        @step_matchers.add(:given, step_matcher)
        @step_matchers.find(:given, "this and that").should equal(step_matcher)
      end
      
      it "should add it matchers to another StepMatchers (with one given)" do
        source = StepMatchers.new
        target = StepMatchers.new
        step_matcher = source.given("this and that") {}
        source.add_to target
        target.find(:given, "this and that").should equal(step_matcher)
      end
      
      it "should add it matchers to another StepMatchers (with some of each type)" do
        source = StepMatchers.new
        target = StepMatchers.new
        given = source.given("1") {}
        when1 = source.when("1") {}
        when2 = source.when("2") {}
        then1 = source.then("1") {}
        then2 = source.then("2") {}
        then3 = source.then("3") {}
        source.add_to target
        target.find(:given, "1").should equal(given)
        target.find(:when, "1").should equal(when1)
        target.find(:when, "2").should equal(when2)
        target.find(:then, "1").should equal(then1)
        target.find(:then, "2").should equal(then2)
        target.find(:then, "3").should equal(then3)
      end
      
      it "should append another collection" do
        matchers_to_append = StepMatchers.new
        step_matcher = matchers_to_append.given("this and that") {}
        @step_matchers << matchers_to_append
        @step_matchers.find(:given, "this and that").should equal(step_matcher)
      end
      
      it "should append several other collections" do
        matchers_to_append = StepMatchers.new
        more_matchers_to_append = StepMatchers.new
        first_matcher = matchers_to_append.given("this and that") {}
        second_matcher = more_matchers_to_append.given("and the other") {}
        @step_matchers << matchers_to_append
        @step_matchers << more_matchers_to_append
        @step_matchers.find(:given, "this and that").should equal(first_matcher)
        @step_matchers.find(:given, "and the other").should equal(second_matcher)
      end
      
      it "should yield itself on initialization" do
        begin
          $step_matchers_spec_matcher = nil
          matchers = StepMatchers.new do |matchers|
            $step_matchers_spec_matcher = matchers.given("foo") {}
          end
          $step_matchers_spec_matcher.matches?("foo").should be_true
        ensure
          $step_matchers_spec_matcher = nil
        end
      end
      
      it "should support defaults" do
        class StepMatchersSubclass < StepMatchers
          step_matchers do |add|
            add.given("foo") {}
          end
        end
        StepMatchersSubclass.new.find(:given, "foo").should_not be_nil
      end
      
    end
  end
end
