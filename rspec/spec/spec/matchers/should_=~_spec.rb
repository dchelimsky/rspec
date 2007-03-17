require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe "should =~" do
  
  it "should delegate message to target" do
    subject = "foo"
    subject.should_receive(:=~).with(/oo/).and_return(true)
    subject.should =~ /oo/
  end
  
  it "should fail when target.=~(actual) returns false" do
    subject = "fu"
    subject.should_receive(:=~).with(/oo/).and_return(false)
    lambda do
      subject.should =~ /oo/
    end.should fail_with(%[expected =~ /oo/, got "fu"])
  end

end

describe "should_not =~" do
  
  it "should delegate message to target" do
    subject = "fu"
    subject.should_receive(:=~).with(/oo/).and_return(false)
    subject.should_not =~ /oo/
  end
  
  it "should fail when target.=~(actual) returns false" do
    subject = "foo"
    subject.should_receive(:=~).with(/oo/).and_return(true)
    lambda do
      subject.should_not =~ /oo/
    end.should fail_with(%[expected not =~ /oo/, got "foo"])
  end

end

