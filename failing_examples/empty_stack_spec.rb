require File.dirname(__FILE__) + '/../lib/spec'
require File.dirname(__FILE__) + "/stack"

context "An empty stack" do
  
  setup do
    @stack = Stack.new
  end
  
  specify "should accept an item when sent push" do
    lambda { @stack.push Object.new }.should_not.raise
  end
  
  specify "should complain when sent top" do
    lambda { @stack.top }.should_raise StackUnderflowError
  end
  
end