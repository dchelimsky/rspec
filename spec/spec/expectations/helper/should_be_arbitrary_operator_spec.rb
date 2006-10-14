require File.dirname(__FILE__) + '/../../../spec_helper'

module Spec
  module Expectations
    module Helper

      context "ShouldBeArbitraryPredicate" do
  
        specify "should pass when == operator returns true" do
          (2+2).should == 4
        end
        
        specify "should fail when == operator returns false" do
          lambda do
            (2+2).should == 5
          end.should_raise(ExpectationNotMetError)
        end

        specify "should pass when =~ operator returns non-nil" do
          "foo".should =~ /oo/
        end

        specify "should fail when =~ operator returns nil" do
          lambda do
            "fu".should =~ /oo/
          end.should_raise(ExpectationNotMetError)
        end

        specify "should pass when < operator returns true" do
          3.should_be < 4
        end

        specify "should fail when > operator returns false" do
          lambda do
            3.should_be > 4
          end.should_raise(ExpectationNotMetError)
        end

      end
      
    end
  end
end
