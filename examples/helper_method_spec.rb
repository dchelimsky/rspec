require File.dirname(__FILE__)  + '/../lib/spec'

context "Rspec" do
  specify "should allow you to define helper methods" do
    a_method
    @a_method_called.should_be true
  end

  def a_method
    @a_method_called = true
  end
end
