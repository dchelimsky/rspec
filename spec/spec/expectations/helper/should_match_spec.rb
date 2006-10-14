require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldMatch" do
    specify "should not raise when objects match" do
        lambda do
          "hi aslak".should_match(/aslak/)
        end.should_not_raise
      
    end
    specify "should raise when objects do not match" do
        lambda do
          "hi aslak".should_match(/steve/)
        end.should_raise(ExpectationNotMetError)
      
    end
  
end
end
end
end