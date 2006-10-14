require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldSatisfy" do
    specify "should not raise exception when block yields true" do
        lambda do
          5.should_satisfy do |target|
            true
          end
        end.should_not_raise
      
    end
    specify "should not raise exception when block yields true again" do
        lambda do
          5.should_not_satisfy do |target|
            false
          end
        end.should_not_raise
      
    end
    specify "should raise exception when block yields false" do
        lambda do
          5.should_satisfy do |target|
            false
          end
        end.should_raise(ExpectationNotMetError)
      
    end
    specify "should raise exception when block yields false again" do
        lambda do
          5.should_not_satisfy do |target|
            true
          end
        end.should_raise(ExpectationNotMetError)
      
    end
  
end
end
end
end