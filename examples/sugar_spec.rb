require File.dirname(__FILE__) + '/../lib/spec'

context "Underscore sugar" do
  specify "should be available for regular objects" do
    1.should_equal 1
    lambda { 1.should_not_equal 1 }.should_raise
  end

  specify "should be available for mocks" do
    sweetened = mock "sweetened"
    sweetened.should_receive :salt
    sweetened.salt
  end
end