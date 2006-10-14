require File.dirname(__FILE__) + '/../../../spec_helper.rb'

module Spec
module Expectations
module Helper
context "ShouldNotBe" do
    setup do
        @dummy = "dummy"
        @equal_dummy = "dummy"
        @another_dummy = "another_dummy"
        @nil_var = nil
      
    end
    specify "should not raise when left is not nil and right is nil" do
        lambda do
          @dummy.should_not_be(nil)
        end.should_not_raise
      
    end
    specify "should not raise when objects are not same" do
        lambda do
          @dummy.should_not_be(@equal_dummy)
        end.should_not_raise
      
    end
    specify "should raise when both objects are nil" do
        lambda do
          @nil_var.should_not_be(nil)
        end.should_raise(ExpectationNotMetError)
      
    end
    specify "should raise when objects are same" do
        lambda do
          @dummy.should_not_be(@dummy)
        end.should_raise(ExpectationNotMetError)
      
    end
  
end
end
end
end