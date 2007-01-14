require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "target.should equal(expected)" do
  specify "should pass if target.equal?(expected)" do
    1.should equal(1)
  end
  
  specify "should fail if !target.equal?(expected)" do
    lambda {
      1.should equal("1")
    }.should_fail_with "expected 1 to equal \"1\" (using .equal?)"
  end
end
  
context "target.should not_equal(expected)" do
  specify "should pass unless target.equal?(expected)" do
    1.should not_equal("1")
  end
  
  specify "should fail unless !target.equal?(expected)" do
    lambda {
      1.should not_equal(1)
    }.should_fail_with "expected 1 to not equal 1 (using .equal?)"
  end
end
  
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
  
context "target.should not_eql(expected)" do
  specify "should pass if !target.eql?(expected)" do
    1.should not_eql("1")
  end
  
  specify "should fail if target.eql?(expected)" do
    lambda {
      1.should not_eql(1)
    }.should_fail_with "expected 1 to not equal 1 (using .eql?)"
  end
end
