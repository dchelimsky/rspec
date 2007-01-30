require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "target.should satisfy { block }" do
  specify "should pass if block returns true" do
    satisfy { |val| val }.matches?(true).should be(true)
  end

  specify "should pass if block returns false" do
    satisfy { |val| val }.matches?(false).should be(false)
  end
  
  specify "should supply failure_message" do
    matcher = satisfy { |val| val }
    
    matcher.matches?(false)
    
    matcher.failure_message.should == "expected false to satisfy block"
  end
  
  specify "should supply failure_message" do
    matcher = satisfy { |val| val }
    
    matcher.matches?(true)
    
    matcher.negative_failure_message.should == "expected true not to satisfy block"
  end
end
