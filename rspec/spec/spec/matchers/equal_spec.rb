require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "should equal(expected)" do
  
  it "should pass if target.equal?(expected)" do
    1.should equal(1)
  end
  
  it "should fail unless target.equal?(expected)" do
    lambda {
      "1".should equal("1")
    }.should fail
  end
  
  it "should provide message, expected and actual on failure" do
    matcher = equal("1")
    matcher.matches?("1")
    matcher.failure_message.should == ["expected \"1\", got \"1\" (using .equal?)", "1", "1"]
  end
  
end

describe "should_not equal(expected)" do
  
  it "should pass unless target.equal?(expected)" do
    "1".should_not equal("1")
  end
  
  it "should fail if target.equal?(expected)" do
    lambda {
      1.should_not equal(1)
    }.should fail
  end
  
  it "should provide message, expected and actual on failure" do
    matcher = equal(1)
    matcher.matches?(1)
    matcher.negative_failure_message.should == ["expected 1 not to equal 1 (using .equal?)", 1, 1]
  end
  
end
