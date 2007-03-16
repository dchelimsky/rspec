require File.dirname(__FILE__) + '/../../spec_helper.rb'

context "should =~" do
  specify "should pass when =~ operator returns non-nil" do
    "foo".should =~ /oo/
    "foo".should_not =~ /oof/
  end

  specify "should fail when =~ operator returns nil" do
    lambda do
      "fu".should =~ /foo/
    end.should fail_with("expected =~ /foo/, got \"fu\"")
    lambda do
      "foo".should_not =~ /oo/
    end.should fail_with("expected not =~ /oo/, got \"foo\"")
  end
end
