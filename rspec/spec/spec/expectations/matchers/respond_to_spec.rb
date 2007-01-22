require File.dirname(__FILE__) + '/../../../spec_helper.rb'

context "Spec::Expectations::Matchers#respond_to behaviour" do
  specify "should return true if starts with be_" do
    matcher = Spec::Expectations::Matcher.new
    matcher.respond_to?(:be_something).should be(true)
  end
  specify "should handle normally otherwise" do
    matcher = Spec::Expectations::Matcher.new
    matcher.respond_to?(:have).should be(true)
    matcher.respond_to?(:non_existent_method).should be(false)
  end
end
