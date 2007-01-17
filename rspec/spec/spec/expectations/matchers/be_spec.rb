require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "be(:sym)" do
  specify "should pass when target returns true for :sym?" do
    target = mock("target")
    target.should_receive(:happy?).and_return(true)
    be(:happy).met_by?(target).should equal(true)
  end

  specify "should fail when target returns false for :sym?" do
    target = mock("target")
    target.should_receive(:happy?).and_return(false)
    be(:happy).met_by?(target).should equal(false)
  end
  
  specify "should fail when target does not respond to :sym?" do
    target = Object.new
    be(:happy).met_by?(target).should equal(false)
  end
  
  specify "should provide failure_message for :sym?" do
    #given
    target = mock("target")
    target.should_receive(:happy?).and_return(false)
    matcher = be(:happy)

    #when
    matcher.met_by?(target)
    
    #then
    matcher.failure_message.should == "expected target to respond to :happy? with true"
  end
  
  specify "should provide negative_failure_message for :sym?" do
    #given
    target = mock("target")
    target.should_receive(:happy?).and_return(true)
    matcher = be(:happy)

    #when
    matcher.met_by?(target)
    
    #then
    matcher.negative_failure_message.should == "expected target to respond to :happy? with false"
  end

  specify "should explain when target does not respond to :sym?" do
    #given
    target = Object.new
    matcher = be(:happy)

    #when
    matcher.met_by?(target)
    
    #then
    matcher.failure_message.should == "target does not respond to :happy?"
    matcher.negative_failure_message.should == "target does not respond to :happy?"
  end
end

context "be(true)" do
  specify "should pass when target equal(true)" do
    be(true).met_by?(true).should equal(true)
  end

  specify "should fail when target equal(false)" do
    be(true).met_by?(false).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(true)
    
    matcher.met_by?(false)
    
    matcher.failure_message.should == "expected true, got false"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(true)
    
    matcher.met_by?(true)
    
    matcher.negative_failure_message.should == "expected not true, got true"
  end
end

context "be(false)" do
  specify "should pass when target equal(false)" do
    be(false).met_by?(false).should equal(true)
  end

  specify "should fail when target equal(true)" do
    be(false).met_by?(true).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(false)
    
    matcher.met_by?(true)
    
    matcher.failure_message.should == "expected false, got true"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(false)
    
    matcher.met_by?(false)
    
    matcher.negative_failure_message.should == "expected not false, got false"
  end
end

context "be(nil)" do
  specify "should pass when target is nil" do
    be(nil).met_by?(nil).should equal(true)
  end

  specify "should fail when target is not nil" do
    be(false).met_by?(true).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(nil)
    
    matcher.met_by?(:not_nil)
    
    matcher.failure_message.should == "expected nil, got :not_nil"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(nil)
    
    matcher.met_by?(nil)
    
    matcher.negative_failure_message.should == "expected not nil, got nil"
  end
end
