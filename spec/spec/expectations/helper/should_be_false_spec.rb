require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Expectations
    module Helper
      context "should_be false" do
        specify "should fail when object is true" do
          lambda do
            true.should_be false
          end.should_raise(ExpectationNotMetError)
        end
    
        specify "should fail when object is a number" do
          lambda do
            5.should_be false
          end.should_raise(ExpectationNotMetError)
        end
    
        specify "should fail when object is a some random object" do
          lambda do
            self.should_be false
          end.should_raise(ExpectationNotMetError)
        end
    
        specify "should fail when object is a string" do
          lambda do
            "false".should_be false
          end.should_raise(ExpectationNotMetError)
        end

        specify "should fail when object is nil" do
          lambda do
            nil.should_be false
          end.should_raise
        end
  
        specify "should pass when object is false" do
          lambda do
            false.should_be false
          end.should_not_raise
        end
      end
    end
  end
end