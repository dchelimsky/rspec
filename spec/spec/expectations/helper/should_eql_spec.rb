require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "should_eql" do
  specify "should pass when objects are equal (by value)" do
    "apple".should_eql("apple")
  end

  specify "should fail when objects are not equal (by value)" do
    lambda { "apple".should_eql("cadillac") }.should_fail
  end
end

context "should_not_eql" do
  specify "should pass when objects are not equal (by value)" do
    "apple".should_not_eql("cadillacs")
  end

  specify "should fail when objects are equal (by value)" do
    lambda { "apple".should_not_eql("apple") }.should_fail
  end
end
