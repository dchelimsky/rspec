require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'spec/expectations/differs/default'

context "should ==" do
  
  specify "should pass when objects are ==" do
    "apple".should == "apple"
    "1".should_not == 1
  end

  specify "should fail when objects are not ==" do
    lambda do
      "1".should == 1
    end.should fail_with("expected 1, got \"1\" (using ==)")
    lambda do
      "apple".should_not == "apple"
    end.should fail_with("expected not == \"apple\", got \"apple\"")
  end

end
