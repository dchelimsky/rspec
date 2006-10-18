require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "should ==" do
  specify "should pass when objects are ==" do
    lambda do
      "apple".should == "apple"
    end.should_pass
  end

  specify "should raise when objects are not ==" do
    lambda do
      "apple".should == "cadillac"
    end.should_fail_with '"apple" should == "cadillac"'
  end
end

context "should_not ==" do
  specify "should fail when objects are ==" do
    lambda do
      "apple".should_not == "apple"
    end.should_fail
  end

  specify "should pass objects are not ==" do
    lambda do
      "apple".should_not == "cadillac"
    end.should_pass
  end
end
