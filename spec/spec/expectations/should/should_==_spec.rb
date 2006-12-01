require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "should ==" do
  specify "should pass when objects are ==" do
    lambda do
      "apple".should == "apple"
    end.should_pass
  end

  specify "should raise exception with diff when objects are not ==" do
    # Please don't change this to non-diffed format - it will break the diffing support.
    lambda do
      "apple".should == "cadillac"
    end.should_fail_with <<-EOD
"apple" should == "cadillac"
Diff:
@@ -1,2 +1,2 @@
-apple
+cadillac
EOD
  end
end
