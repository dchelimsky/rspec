require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldThrow" do
    specify "should fail when no symbol is thrown" do
        lambda do
          lambda do
            "".to_s
          end.should_throw(:foo)
        end.should_raise(ExpectationNotMetError)
      
    end
    specify "should fail when wrong symbol is thrown" do
        lambda do
          lambda do
            throw(:bar)
          end.should_throw(:foo)
        end.should_raise(ExpectationNotMetError)
      
    end
    specify "should pass when proper symbol is thrown" do
        lambda do
          lambda do
            throw(:foo)
          end.should_throw(:foo)
        end.should_not_raise
      
    end
  
end
end
end
end