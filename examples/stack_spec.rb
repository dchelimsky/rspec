context "An empty stack" do
  
  setup do
    @stack = Stack.new
  end
  
  specify "should accept an item when sent push" do
    lambda { @stack.push Object.new }.should.not.raise
  end
  
  specify "should complain when sent top" do
    lambda { @stack.top }.should.raise StackUnderflowError
  end
  
  specify "should complain when sent pop" do
    lambda { @stack.pop }.should.raise StackUnderflowError
  end
  
end

context "A stack with one item" do
  setup do
    @stack = Stack.new
    @stack.push 3
  end

  specify "should accept an item when sent push" do
    lambda { @stack.push Object.new }.should.not.raise
  end
  
  specify "should return top when sent top" do
    @stack.top.should.be 3
  end
  
  specify "should not remove top when sent top" do
    @stack.top.should.be 3
    @stack.top.should.be 3
  end
  
  specify "should return top when sent pop" do
    @stack.pop.should.be 3
  end
  
  specify "should remove top when sent pop" do
    @stack.pop.should.be 3
    lambda { @stack.pop }.should.raise StackUnderflowError
  end
  
end

context "An almost full stack (with one item less than capacity)" do
  setup do
    @stack = Stack.new
    (1..9).each { |i| @stack.push i }
  end

  specify "should accept an item when sent push" do
    @stack.push Object.new
  end
  
  specify "should return top when sent top" do
    @stack.top.should.be 9
  end
  
  specify "should not remove top when sent top" do
    @stack.top.should.be 9
    @stack.top.should.be 9
  end
  
  specify "should return top when sent pop" do
    @stack.pop.should.be 9
  end
  
  specify "should remove top when sent pop" do
    @stack.pop.should.be 9
    @stack.pop.should.be 8
  end
  
end
context "A full stack" do
  
  setup do
    @stack = Stack.new
    (1..10).each { |i| @stack.push i }
  end

  specify "should complain on push" do
    lambda { @stack.push Object.new }.should.raise StackOverflowError
  end
  
  specify "should return top when sent top" do
    @stack.top.should.be 10
  end
  
  specify "should not remove top when sent top" do
    @stack.top.should.be 10
    @stack.top.should.be 10
  end
  
  specify "should return top when sent pop" do
    @stack.pop.should.be 10
  end
  
  specify "should remove top when sent pop" do
    @stack.pop.should.be 10
    @stack.pop.should.be 9
  end
  
end



