require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Expectations
    module Helper
      context "ShouldBeFalse" do
        specify "should raise when object is true" do
          lambda do
            true.should_be(false)
          end.should_raise(ExpectationNotMetError)
        end
    
        specify "shouldnt raise when object is a number" do
          lambda do
            5.should_be(false)
          end.should_raise(ExpectationNotMetError)
        end
    
        specify "shouldnt raise when object is a some random object" do
          lambda do
            self.should_be(false)
          end.should_raise(ExpectationNotMetError)
        end
    
        specify "shouldnt raise when object is a string" do
          lambda do
            "hello".should_be(false)
          end.should_raise(ExpectationNotMetError)
        end
  
        specify "shouldnt raise when object is false" do
          lambda do
            false.should_be(false)
          end.should_not_raise
        end
    
        specify "shouldnt raise when object is nil" do
          lambda do
            nil.should_be(false)
          end.should_not_raise
        end
      end
    end
  end
end