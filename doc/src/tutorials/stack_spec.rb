require File.dirname(__FILE__) + "/stack"

context "An empty stack" do
  
  setup do
    @stack = Stack.new
  end
  
  specify "should keep its mouth shut when you send it the push message" do
     lambda { @stack.push Object.new }.should.not.raise Exception
  end
  
  specify "should raise a StackUnderflowError when you send it the top message" do
    lambda { @stack.top }.should.raise StackUnderflowError
  end
  
end

context "A stack with one item" do
  
  setup do
    @stack = Stack.new
    @stack.push "one item"
  end

  specify "should return top when sent the message top" do
    @stack.top.should.equal "one item"
  end
  
end
