require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module Matchers
    describe SimpleMatcher do
      it "should match pass match arg to block" do
        actual = nil
        matcher = SimpleMatcher.new("message") do |given| actual = given end
        matcher.matches?("foo")
        actual.should == "foo"
      end
      
      it "should provide a stock failure message" do
        matcher = SimpleMatcher.new("thing") do end
        matcher.matches?("other")
        matcher.failure_message.should =~ /Expected \"thing\" but got \"other\"/
      end
      
      it "should provide a stock negative failure message" do
        matcher = SimpleMatcher.new("thing") do end
        matcher.matches?("other")
        matcher.negative_failure_message.should =~ /Expected not to get \"thing\", but got \"other\"/
      end
    end
  end
end