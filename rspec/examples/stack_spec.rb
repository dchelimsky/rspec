require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + "/stack"

describe "non-empty Stack", :shared => true do
  # NOTE that this one auto-generates the description "should not be empty"
  specify { @stack.should_not be_empty }
  
  it "should return the top item when sent #peek" do
    @stack.peek.should == @last_item_added
  end

  it "should NOT remove the top item when sent #peek" do
    @stack.peek.should == @last_item_added
    @stack.peek.should == @last_item_added
  end
  
  it "should return the top item when sent #pop" do
    @stack.pop.should == @last_item_added
  end
  
  it "should remove the top item when sent #pop" do
    @stack.pop.should == @last_item_added
    unless @stack.empty?
      @stack.pop.should_not == @last_item_added
    end
  end
end

describe "non-full Stack", :shared => true do
  # NOTE that this one auto-generates the description "should not be full"
  specify { @stack.should_not be_full }

  it "should add to the top when sent #push" do
    @stack.push "newly added top item"
    @stack.peek.should == "newly added top item"
  end
end

describe Stack, " (empty)" do
  setup do
    @stack = Stack.new
  end
  
  # NOTE that this one auto-generates the description "should be empty"
  specify { @stack.should be_empty }
  
  it_should_behave_like "non-full Stack"
  
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

describe Stack, " (with one item)" do
  setup do
    @stack = Stack.new
    @stack.push 3
    @last_item_added = 3
  end

  # NOTE that this one auto-generates the description "should not be full"
  specify { @stack.should_not be_empty }
  
  it_should_behave_like "non-empty Stack"
  
  it "should remain not empty after #peek" do
    @stack.peek
    @stack.should_not be_empty
  end
  
  it "should become empty after #pop" do
    @stack.pop
    @stack.should be_empty
  end
end

describe Stack, " (with one item less than capacity)" do
  setup do
    @stack = Stack.new
    (1..9).each { |i| @stack.push i }
    @last_item_added = 9
  end
  
  # NOTE that this one auto-generates the description "should not be full"
  specify { @stack.should_not be_full }

  it_should_behave_like "non-empty Stack"
  
  it "should become full after #push" do
    @stack.push Object.new
    @stack.should be_full
  end
end

describe Stack, " (full)" do
  setup do
    @stack = Stack.new
    (1..10).each { |i| @stack.push i }
    @last_item_added = 10
  end
  
  # NOTE that this one auto-generates the description "should be full"
  it { @stack.should be_full }
  
  it_should_behave_like "non-empty Stack"
  
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