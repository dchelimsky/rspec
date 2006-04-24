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
  
  specify "should raise a StackUnderflowError when you send it 'pop'" do
    lambda { @stack.pop }.should.raise StackUnderflowError
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

  specify "should return top repeatedly when you send it 'top'" do
    @stack.top
    @stack.top.should.equal "one item"
    @stack.top.should.equal "one item"
  end
  
  specify "should return top when you send it 'pop'" do
    @stack.pop.should.equal "one item"
  end
  
  specify "should raise a StackUnderflowError the second time you sent it 'pop'" do
    @stack.pop
    lambda { @stack.pop }.should.raise StackUnderflowError
  end
  
end
