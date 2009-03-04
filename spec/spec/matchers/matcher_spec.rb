require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Matchers
    describe Spec::Matchers::Matcher do
      context "without overrides" do
        before(:each) do
          @matcher = Spec::Matchers::Matcher.new(:be_a_multiple_of, 3) do |multiple|
            match do |actual|
              actual % multiple == 0
            end
          end
        end
        
        it "provides a default description" do
          @matcher.matches?(0)
          @matcher.description.should == "be a multiple of 3"
        end

        it "provides a default failure message for #should" do
          @matcher.matches?(8)
          @matcher.failure_message_for_should.should == "expected 8 to be a multiple of 3"
        end

        it "provides a default failure message for #should_not" do
          @matcher.matches?(9)
          @matcher.failure_message_for_should_not.should == "expected 9 not to be a multiple of 3"
        end
      end
      
      context "with overrides" do
        before(:each) do
          @matcher = Spec::Matchers::Matcher.new(:be_boolean, true) do |boolean|
            match do |actual|
              actual
            end
            description do
              "be the boolean #{boolean}"
            end
            failure_message_for_should do |actual|
              "expected #{actual} to be the boolean #{boolean}"
            end
            failure_message_for_should_not do |actual|
              "expected #{actual} not to be the boolean #{boolean}"
            end
          end
        end

        it "does not hide result of match block when true" do
          @matcher.matches?(true).should be_true
        end

        it "does not hide result of match block when false" do
          @matcher.matches?(false).should be_false
        end

        it "overrides the description" do
          @matcher.matches?(true)
          @matcher.description.should == "be the boolean true"
        end

        it "overrides the failure message for #should" do
          @matcher.matches?(false)
          @matcher.failure_message_for_should.should == "expected false to be the boolean true"
        end
        
        it "overrides the failure message for #should_not" do
          @matcher.matches?(true)
          @matcher.failure_message_for_should_not.should == "expected true not to be the boolean true"
        end
      end
      
      context "#new" do
        it "passes matches? arg to match block" do
          matcher = Spec::Matchers::Matcher.new(:ignore) do 
            match do |actual|
              actual == 5
            end
          end
          matcher.matches?(5).should be_true
        end

        it "exposes arg submitted through #new to matcher block" do
          matcher = Spec::Matchers::Matcher.new(:ignore, 4) do |expected|
            match do |actual|
              actual > expected
            end
          end
          matcher.matches?(5).should be_true
        end
      end

      context "matching with overrides" do
      end
    end
  end
end
