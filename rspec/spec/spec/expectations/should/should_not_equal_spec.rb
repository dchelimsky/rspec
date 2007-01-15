require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "should_not_equal" do
  specify "should pass when objects are not the same instance" do
    "apple".should_not_equal("apple")
    "apple".should_not.equal("apple")
    "apple".should_not equal("apple")
  end

  specify "should fail when objects are the same instance" do
    lambda { :apple.should_not_equal(:apple) }.should_fail_with "expected :apple to not equal :apple (using .equal?)"
    lambda { :apple.should_not.equal(:apple) }.should_fail_with "expected :apple to not equal :apple (using .equal?)"
    lambda { :apple.should_not equal(:apple) }.should_fail_with "expected :apple to not equal :apple (using .equal?)"
  end
end
