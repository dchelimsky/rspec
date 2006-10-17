require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
  module Expectations
    module Helper
      context "Should ==" do
        specify "should not raise when objects are ==" do
          lambda do
            "apple".should == "apple"
          end.should_not_raise
        end

        specify "should raise when objects are not ==" do
          lambda do
            "apple".should == "orange"
          end.should_raise(ExpectationNotMetError, '"apple" should == "orange"')
        end
      end
    end
  end
end