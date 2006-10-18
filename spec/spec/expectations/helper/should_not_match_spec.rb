require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldNotMatch" do
    specify "should not raise when objects do not match" do
        lambda do
          "hi aslak".should_not_match(/steve/)
        end.should_not_raise
      
    end
    specify "should raise when objects match" do
        lambda do
          "hi aslak".should_not_match(/aslak/)
        end.should_fail
      
    end
  
end
end
end
end