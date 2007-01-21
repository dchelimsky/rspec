require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "be(:sym)" do
  specify "should pass when target returns true for :sym?" do
    target = mock("target")
    target.should_receive(:happy?).and_return(true)
    be(:happy).matches?(target).should equal(true)
  end

  specify "should fail when target returns false for :sym?" do
    target = mock("target")
    target.should_receive(:happy?).and_return(false)
    be(:happy).matches?(target).should equal(false)
  end
  
  specify "should fail when target does not respond to :sym?" do
    target = Object.new
    be(:happy).matches?(target).should equal(false)
  end
  
  specify "should provide failure_message for :sym?" do
    #given
    target = mock("target")
    target.should_receive(:happy?).and_return(false)
    matcher = be(:happy)

    #when
    matcher.matches?(target)
    
    #then
    matcher.failure_message.should == "expected actual.happy? to return true, got false"
  end
  
  specify "should provide negative_failure_message for :sym?" do
    #given
    target = mock("target")
    target.should_receive(:happy?).and_return(true)
    matcher = be(:happy)

    #when
    matcher.matches?(target)
    
    #then
    matcher.negative_failure_message.should == "expected actual.happy? to return false, got true"
  end

  specify "should explain when target does not respond to :sym?" do
    #given
    target = Object.new
    matcher = be(:happy)

    #when
    matcher.matches?(target)
    
    #then
    matcher.failure_message.should == "actual does not respond to #happy?"
    matcher.negative_failure_message.should == "actual does not respond to #happy?"
  end
end

context "be(true)" do
  specify "should pass when target equal(true)" do
    be(true).matches?(true).should equal(true)
  end

  specify "should fail when target equal(false)" do
    be(true).matches?(false).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(true)
    
    matcher.matches?(false)
    
    matcher.failure_message.should == "expected true, got false"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(true)
    
    matcher.matches?(true)
    
    matcher.negative_failure_message.should == "expected not true, got true"
  end
end

context "be(false)" do
  specify "should pass when target equal(false)" do
    be(false).matches?(false).should equal(true)
  end

  specify "should fail when target equal(true)" do
    be(false).matches?(true).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(false)
    
    matcher.matches?(true)
    
    matcher.failure_message.should == "expected false, got true"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(false)
    
    matcher.matches?(false)
    
    matcher.negative_failure_message.should == "expected not false, got false"
  end
end

context "be(nil)" do
  specify "should pass when target is nil" do
    be(nil).matches?(nil).should equal(true)
  end

  specify "should fail when target is not nil" do
    be(false).matches?(true).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(nil)
    
    matcher.matches?(:not_nil)
    
    matcher.failure_message.should == "expected nil, got :not_nil"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(nil)
    
    matcher.matches?(nil)
    
    matcher.negative_failure_message.should == "expected not nil, got nil"
  end
end
