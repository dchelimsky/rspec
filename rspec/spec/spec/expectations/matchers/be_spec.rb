require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "be(:sym?)" do
  specify "should pass when actual returns true for :sym?" do
    actual = mock("actual")
    actual.should_receive(:happy?).and_return(true)
    be(:happy?).matches?(actual).should equal(true)
  end

  specify "should fail when actual returns false for :sym?" do
    actual = mock("actual")
    actual.should_receive(:happy?).and_return(false)
    be(:happy?).matches?(actual).should equal(false)
  end
  
  specify "should fail when actual does not respond to :sym?" do
    lambda {
      be(:happy?).matches?(Object.new)
    }.should_fail_with "target does not respond to #happy?"
  end
  
  specify "should provide failure_message for :sym?" do
    #given
    actual = mock("actual")
    actual.should_receive(:happy?).and_return(false)
    matcher = be(:happy?)

    #when
    matcher.matches?(actual)
    
    #then
    matcher.failure_message.should == "expected happy? to return true, got false"
  end
  
  specify "should provide negative_failure_message for :sym?" do
    #given
    actual = mock("actual")
    actual.should_receive(:happy?).and_return(true)
    matcher = be(:happy?)

    #when
    matcher.matches?(actual)
    
    #then
    matcher.negative_failure_message.should == "expected happy? to return false, got true"
  end
end

context "be(:sym, *args)" do
  specify "should pass when actual returns true for :sym?(*args)" do
    actual = mock("actual")
    actual.should_receive(:older_than?).with(3).and_return(true)
    be(:older_than?, 3).matches?(actual).should equal(true)
  end

  specify "should fail when actual returns false for :sym?(*args)" do
    actual = mock("actual")
    actual.should_receive(:older_than?).with(3).and_return(false)
    be(:older_than?, 3).matches?(actual).should equal(false)
  end
  
  specify "should fail when actual does not respond to :sym?" do
    lambda { be(:happy?, 3).matches?(Object.new) }.should_fail_with "target does not respond to #happy?"
  end
  
  specify "should provide failure_message for :sym?(*args) with one arg" do
    #given
    actual = mock("actual")
    actual.should_receive(:older_than?).with(3).and_return(false)
    matcher = be(:older_than?, 3)
  
    #when
    matcher.matches?(actual)
    
    #then
    matcher.failure_message.should == "expected older_than?(3) to return true, got false"
  end
  
  specify "should provide failure_message for :sym?(*args) with multi args" do
    #given
    actual = mock("actual")
    actual.should_receive(:ok_with?).with(3, "a", obj = Object.new).and_return(false)
    matcher = be(:ok_with?, 3, "a", obj)
  
    #when
    matcher.matches?(actual)
    
    #then
    matcher.failure_message.should =~ /expected ok_with\?\(3, \"a\", #<Object:.*>\) to return true, got false/
  end
  
  specify "should provide negative_failure_message for :sym?(*args) with one arg" do
    #given
    actual = mock("actual")
    actual.should_receive(:older_than?).with(3).and_return(true)
    matcher = be(:older_than?, 3)
  
    #when
    matcher.matches?(actual)
    
    #then
    matcher.negative_failure_message.should == "expected older_than?(3) to return false, got true"
  end
  
  specify "should provide failure_message for :sym?(*args) with multi args" do
    #given
    actual = mock("actual")
    actual.should_receive(:ok_with?).with(3, "a", obj = Object.new).and_return(false)
    matcher = be(:ok_with?, 3, "a", obj)
  
    #when
    matcher.matches?(actual)
    
    #then
    matcher.negative_failure_message.should =~ /expected ok_with\?\(3, \"a\", #<Object:.*>\) to return false, got true/
  end
end

context "be(:true?)" do
  specify "should pass when actual equal(true)" do
    be(:true?).matches?(true).should equal(true)
  end

  specify "should fail when actual equal(false)" do
    be(:true?).matches?(false).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(:true?)
    
    matcher.matches?(false)
    
    matcher.failure_message.should == "expected true, got false"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(:true?)
    
    matcher.matches?(true)
    
    matcher.negative_failure_message.should == "expected not true, got true"
  end
end

context "be(:false?)" do
  specify "should pass when actual equal(false)" do
    be(:false?).matches?(false).should equal(true)
  end

  specify "should fail when actual equal(true)" do
    be(:false?).matches?(true).should equal(false)
  end
  
  specify "should provide failure_message" do
    matcher = be(:false?)
    
    matcher.matches?(true)
    
    matcher.failure_message.should == "expected false, got true"
  end
  
  specify "should provide negative_failure_message" do
    matcher = be(:false?)
    
    matcher.matches?(false)
    
    matcher.negative_failure_message.should == "expected not false, got false"
  end
end

context "be(nil)" do
  specify "should pass when actual is nil" do
    be(nil).matches?(nil).should equal(true)
  end

  specify "should fail when actual is not nil" do
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

context "should be <" do
  specify "should pass when < operator returns true" do
    3.should be < 4
  end

  specify "should fail when < operator returns false" do
    lambda { 3.should be < 3 }.should_fail_with "expected < 3, got 3"
  end
end

context "should be <=" do
  specify "should pass when <= operator returns true" do
    3.should be <= 4
    4.should be <= 4
  end

  specify "should fail when <= operator returns false" do
    lambda { 3.should be <= 2 }.should_fail_with "expected <= 2, got 3"
  end
end

context "should be >=" do
  specify "should pass when >= operator returns true" do
    4.should be >= 4
    5.should be >= 4
  end

  specify "should fail when >= operator returns false" do
    lambda { 3.should be >= 4 }.should_fail_with "expected >= 4, got 3"
  end
end

context "should be >" do
  specify "should pass when > operator returns true" do
    5.should be > 4
  end

  specify "should fail when > operator returns false" do
    lambda { 3.should be > 4 }.should_fail_with "expected > 4, got 3"
  end
end


