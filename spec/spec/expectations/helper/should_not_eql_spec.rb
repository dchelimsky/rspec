require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldNotEqual" do
    specify "should not equal should raise when objects are equal" do
        lambda do
          "apple".should_not_eql("apple")
        end.should_fail
      
    end
    specify "should not raise when objects are not equal" do
        lambda do
          "apple".should_not_eql("orange")
        end.should_not_raise
      
    end
  
end
end
end
end