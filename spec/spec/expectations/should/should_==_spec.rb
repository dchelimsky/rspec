require File.dirname(__FILE__) + '/../../../spec_helper.rb'

require 'spec/expectations/differs/default'

context "should ==" do
  specify "should pass when objects are ==" do
    lambda do
      "apple".should == "apple"
    end.should_pass
  end

  specify "should raise exception with diff when objects are not ==" do
    # Please don't change this to non-diffed format - it will break the diffing support.
    # Spec::Expectations::Should::Base.differ = Spec::Expectations::Differs::Default
    lambda do
      "apple".should == "cadillac"
    end.should_fail_with <<-EOD
"apple" should == "cadillac"
Diff:
@@ -1,2 +1,2 @@
-apple
+cadillac
EOD
    # Spec::Expectations::Should::Base.differ = nil
  end
end
