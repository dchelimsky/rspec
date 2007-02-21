require 'stack'

context "A new stack" do
  setup do
    @stack = Stack.new
  end

  specify "should be empty" do
    @stack.should be_empty
  end
end

context "A stack with one item" do
  setup do
    @stack = Stack.new
    @stack.push "one item"
  end

  specify "should return top when you send it 'top'" do
    @stack.top.should == "one item"
  end

  specify "should not be empty" do
    @stack.should_not be_empty
  end
end