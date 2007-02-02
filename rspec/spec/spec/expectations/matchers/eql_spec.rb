require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "eql(expected)" do
  
  specify "should pass if target.eql?(expected)" do
    matcher = eql(1)
    matcher.matches?(1).should be_true
    matcher.negative_failure_message.should == ["expected 1 not to equal 1 (using .eql?)", 1, 1]
  end
  
  specify "should fail if !target.eql?(expected)" do
    matcher = eql("1")
    matcher.matches?(1).should be_false
    matcher.failure_message.should == ["expected \"1\", got 1 (using .eql?)", "1", 1]
  end
  
end
