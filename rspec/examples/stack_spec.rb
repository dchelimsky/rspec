require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + "/stack"

describe "Stack" do
  setup do
    @stack = Stack.new
    ["a","b","c"].each { |x| @stack.push x }
  end
  
  it "should add to the top when sent #push" do
    @stack.push "d"
    @stack.peek.should == "d"
  end
  
  it "should return the top item when sent #peek" do
    @stack.peek.should == "c"
  end
  
  it "should NOT remove the top item when sent #peek" do
    @stack.peek.should == "c"
    @stack.peek.should == "c"
  end
  
  it "should return the top item when sent #pop" do
    @stack.pop.should == "c"
  end
  
  it "should remove the top item when sent #pop" do
    @stack.pop.should == "c"
    @stack.pop.should == "b"
  end
end

describe Stack, "(empty)" do
  setup do
    @stack = Stack.new
  end
  
  # NOTE that this one auto-generates the description "should be empty"
  specify { @stack.should be_empty }
  
  it "should no longer be empty after #push" do
    @stack.push "anything"
    @stack.should_not be_empty
  end
  
  it "should complain when sent #peek" do
    lambda { @stack.peek }.should raise_error(StackUnderflowError)
  end
  
  it "should complain when sent #pop" do
    lambda { @stack.pop }.should raise_error(StackUnderflowError)
  end
end

describe Stack, "(with one item)" do
  setup do
    @stack = Stack.new
    @stack.push 3
  end
  
  # NOTE that this one auto-generates the description "should not be empty"
  specify { @stack.should_not be_empty }
  
  it "should remain not empty after #peek" do
    @stack.peek
    @stack.should_not be_empty
  end
  
  it "should become empty after #pop" do
    @stack.pop
    @stack.should be_empty
  end
end

describe Stack, "(with one item less than capacity)" do
  setup do
    @stack = Stack.new
    (1..9).each { |i| @stack.push i }
  end
  
  # NOTE that this one auto-generates the description "should not be full"
  specify { @stack.should_not be_full }
  
  it "should become full after #push" do
    @stack.push Object.new
    @stack.should be_full
  end
end

describe Stack, "(full)" do
  setup do
    @stack = Stack.new
    (1..10).each { |i| @stack.push i }
  end
  
  # NOTE that this one auto-generates the description "should be full"
  it { @stack.should be_full }
  
  it "should remain full after #peek" do
    @stack.peek
    @stack.should be_full
  end
  
  it "should no longer be full after #pop" do
    @stack.pop
    @stack.should_not be_full
  end

  it "should complain on #push" do
    lambda { @stack.push Object.new }.should raise_error(StackOverflowError)
  end
end