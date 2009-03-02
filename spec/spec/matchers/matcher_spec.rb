require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Matchers
    describe "#create" do
      it "creates a matcher" do
        Spec::Matchers.create(:custom_matcher_for_example) do |a,b|
          match { a == b }
        end
        custom_matcher_for_example(5).matches?(5).should be_true
      end
    end
    
    describe Matcher do

      it "passes" do
        actual, expected = 3, 3
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match do
            expected == actual
          end
        end
        matcher.matches?(actual).should be(true)
      end

      it "fails" do
        actual, expected = 3, 2
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match do
            expected == actual
          end
        end
        matcher.matches?(actual).should be(false)
      end
      
      it "accepts multiple args" do
        actual, expected, delta = 3.0, 2.9, 0.2
        matcher = Spec::Matchers::Matcher.new(:be_close_to, expected, delta) do
          match do
            (actual - expected).abs < delta
          end
        end
        matcher.matches?(actual).should be(true)
      end
      
      it "provides a default failure message" do
        actual, expected = 3, 2
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match do
            expected == actual
          end
        end
        matcher.matches?(actual)
        matcher.failure_message.should == "expected 3 to be something like 2"
      end
      
      it "overrides the failure message" do
        actual, expected = 3, 2
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match {expected == actual}
          failure_message_for(:should) {"message for should"}
        end
        matcher.matches?(actual)
        matcher.failure_message.should == "message for should"
      end
      
      it "provides a default negative failure message" do
        actual, expected = 3, 3
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match do
            expected == actual
          end
        end
        matcher.matches?(actual)
        matcher.negative_failure_message.should == "expected 3 to not be something like 3"
      end

      it "overrides the failure message for should_not" do
        actual, expected = 3, 2
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match {expected == actual}
          failure_message_for(:should_not) {"message for should not"}
        end
        matcher.matches?(actual)
        matcher.negative_failure_message.should == "message for should not"
      end
      
      it "provides a default description" do
        actual, expected = 3, 2
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match {expected == actual}
        end
        matcher.matches?(actual)
        matcher.description.should == "be something like 2"
      end
      
      it "overrides the description" do
        actual, expected = 3, 2
        matcher = Spec::Matchers::Matcher.new(:be_something_like, expected) do
          match {expected == actual}
          description {"be something a lot like 3"}
        end
        matcher.matches?(actual)
        matcher.description.should == "be something a lot like 3"
      end
      
    end
  end
end
