require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "should eql(expected)" do
  
  it "should pass if target.eql?(expected)" do
    1.should eql(1)
  end
  
  it "should fail unless target.eql?(expected)" do
    lambda {
      1.should eql("1")
    }.should fail
  end
  
  it "should provide message, expected and actual on failure" do
    matcher = eql("1")
    matcher.matches?(1)
    matcher.failure_message.should == ["expected \"1\", got 1 (using .eql?)", "1", 1]
  end
  
end

describe "should_not eql(expected)" do
  
  it "should pass unless target.eql?(expected)" do
    1.should_not eql("1")
  end
  
  it "should fail if target.eql?(expected)" do
    lambda {
      1.should_not eql(1)
    }.should fail
  end
  
  it "should provide message, expected and actual on failure" do
    matcher = eql(1)
    matcher.matches?(1)
    matcher.negative_failure_message.should == ["expected 1 not to equal 1 (using .eql?)", 1, 1]
  end
  
end
