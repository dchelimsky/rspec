require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "target.should match(expected)" do
  specify "should pass when target (String) matches expected (Regexp)" do
    match(/tri/).matches?("string").should be(true)
  end

  specify "should fail when target (String) matches expected (Regexp)" do
    match(/rings/).matches?("string").should be(false)
  end

  specify "should provide a failure_message" do
    matcher = match(/rings/)
    matcher.matches?("string")
    matcher.failure_message.should == "expected \"string\" to match /rings/"
  end

  specify "should provide a negative_failure_message" do
    matcher = match(/ring/)
    matcher.matches?("string")
    matcher.negative_failure_message.should == "expected \"string\" not to match /ring/"
  end
end
