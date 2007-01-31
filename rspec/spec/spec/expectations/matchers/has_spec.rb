require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "Has.new(:sym)" do
  specify "should match if has_sym? returns true" do
    Spec::Expectations::Matchers::Has.new(:key, :a).matches?({:a => "A"}).should be_true
  end

  specify "should not match if target has_sym? returns false" do
    matcher = Spec::Expectations::Matchers::Has.new(:key, :a)
    matcher.matches?({:b => "A"}).should be_false
    matcher.failure_message.should == "expected #has_key?(:a) to return true, got false"
  end

  specify "should not match if target does not respond to has_sym?" do
    matcher = Spec::Expectations::Matchers::Has.new(:key, :a)
    matcher.matches?(Object.new).should be_false
    matcher.failure_message.should == "target does not respond to #has_key?"
  end
  
  specify "should have negative failure message when has_sym? returns true" do
    matcher = Spec::Expectations::Matchers::Has.new(:key, :a)
    matcher.matches?({:a => "A"})
    matcher.negative_failure_message.should == "expected #has_key?(:a) to return false, got true"
  end
  
  specify "should have negative failure message when target does not respond to has_sym?" do
    matcher = Spec::Expectations::Matchers::Has.new(:key, :a)
    matcher.matches?(Object.new)
    matcher.negative_failure_message.should == "target does not respond to #has_key?"
  end
end
