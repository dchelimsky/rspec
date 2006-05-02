require File.dirname(__FILE__) + '/../lib/spec'

context "The --sweet option" do
  specify "should make rspec understand underscores for regular objects" do
    1.should_equal 1
    lambda { 1.should_not_equal 1 }.should_raise
  end

  specify "should make rspec understand underscores for mocks" do
    sweetened = mock "sweetened"
    sweetened.should_receive :salt
    sweetened.salt
  end
end