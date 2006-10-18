require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldEqual" do
    specify "should not raise when objects are equal" do
        lambda do
          "apple".should_eql("apple")
        end.should_not_raise
      
    end
    specify "should raise when objects are not equal" do
        lambda do
          "apple".should_eql("orange")
        end.should_raise(ExpectationNotMetError)
      
    end
  
end
end
end
end