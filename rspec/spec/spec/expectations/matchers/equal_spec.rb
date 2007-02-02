require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "equal(expected)" do
  
  specify "should pass if target.equal?(expected)" do
    matcher = equal(1)
    matcher.matches?(1).should be_true
    matcher.negative_failure_message.should == ["expected 1 not to equal 1 (using .equal?)", 1, 1]
  end
  
  specify "should fail if !target.equal?(expected)" do
    matcher = equal("1")
    matcher.matches?(1).should be_false
    matcher.failure_message.should == ["expected \"1\", got 1 (using .equal?)", "1", 1]
  end
  
end
