require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "target.should eql(expected)" do
  specify "should pass if target.eql?(expected)" do
    1.should eql(1)
  end
  
  specify "should fail if !target.eql?(expected)" do
    lambda {
      1.should eql("1")
    }.should_fail_with "expected 1 to equal \"1\" (using .eql?)"
  end
end
  
context "target.should_not eql(expected)" do
  specify "should pass if !target.eql?(expected)" do
    1.should_not eql("1")
  end
  
  specify "should fail if target.eql?(expected)" do
    lambda {
      1.should_not eql(1)
    }.should_fail_with "expected 1 not to equal 1 (using .eql?)"
  end
end
