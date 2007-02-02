require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "respond_to" do
  
  specify "should match if target responds to :sym" do
    matcher = respond_to(:methods)
    matcher.matches?(Object.new).should be_true
    matcher.negative_failure_message.should == "expected target not to respond to :methods"
  end
  
  specify "should not match if target responds to :sym" do
    matcher = respond_to(:some_method)
    matcher.matches?(Object.new).should be_false
    matcher.failure_message.should == "expected target to respond to :some_method"
  end
  
end
