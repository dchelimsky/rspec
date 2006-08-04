require File.dirname(__FILE__)  + '/../lib/spec'

context "Rspec allow you to define custom methods" do
  specify "Rspec should allow you to define methods" do
    a_method
    @a_method_called.should_be true
  end

  def a_method
    @a_method_called = true
  end
end
require File.dirname(__FILE__)  + '/../lib/spec'

context "Rspec allow you to define custom methods" do
  specify "Rspec should allow you to define methods" do
    a_method
    @a_method_called.should_be true
  end

  def a_method
    @a_method_called = true
  end
end
