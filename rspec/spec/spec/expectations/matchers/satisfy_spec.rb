require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "target.should satisfy { block }" do
  specify "should pass if block returns true" do
    satisfy { |val| val }.met_by?(true).should be(true)
  end

  specify "should pass if block returns false" do
    satisfy { |val| val }.met_by?(false).should be(false)
  end
  
  specify "should supply failure_message" do
    matcher = satisfy { |val| val }
    
    matcher.met_by?(false)
    
    matcher.failure_message.should == "expected false to satisfy block"
  end
  
  specify "should supply failure_message" do
    matcher = satisfy { |val| val }
    
    matcher.met_by?(true)
    
    matcher.negative_failure_message.should == "expected true to not satisfy block"
  end
end
