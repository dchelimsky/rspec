require File.dirname(__FILE__) + "/stack"

context "An empty stack" do
  
  setup do
    @stack = Stack.new
  end
  
  specify "should keep its mouth shut when you send it 'push'" do
     lambda { @stack.push Object.new }.should.not.raise Exception
  end
  
  specify "should raise a StackUnderflowError when you send it 'top'" do
    lambda { @stack.top }.should.raise StackUnderflowError
  end
  
end

context "A stack with one item" do
  
  setup do
    @stack = Stack.new
    @stack.push "one item"
  end

  specify "should keep its mouth shut when you send it 'push'" do
     lambda { @stack.push Object.new }.should.not.raise Exception
  end
  
  specify "should return top when you send it 'top'" do
    @stack.top.should.equal "one item"
  end
  
end
