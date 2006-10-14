require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldNotBeAnInstanceOf" do
    specify "should fail when target is of specified class" do
        lambda do
          "hello".should_not_be_an_instance_of(String)
        end.should_raise(ExpectationNotMetError)
      
    end
    specify "should pass when target is not of specified class" do
        lambda do
          [].should_not_be_an_instance_of(String)
        end.should_not_raise
      
    end
  
end
end
end
end