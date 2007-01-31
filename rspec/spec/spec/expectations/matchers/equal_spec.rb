require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "target.should equal(expected)" do
  
  specify "should pass if target.equal?(expected)" do
    1.should equal(1)
  end
  
  specify "should fail if !target.equal?(expected)" do
    lambda {
      1.should equal("1")
    }.should_fail_with "expected \"1\", got 1 (using .equal?)"
  end
  
end
  
context "target.should_not equal(expected)" do
  specify "should pass unless target.equal?(expected)" do
    1.should_not equal("1")
  end
  
  specify "should fail unless !target.equal?(expected)" do
    lambda {
      1.should_not equal(1)
    }.should_fail_with "expected 1 not to equal 1 (using .equal?)"
  end
end
