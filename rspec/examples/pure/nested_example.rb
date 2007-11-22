require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/stack'

# TODO - this runs and does the right thing except for
# output - "Stack" never appears. Getting close though.

describe Stack do
  before(:each) do
    @stack = Stack.new
  end
  
  describe "when empty" do
    it "should be empty" do
      @stack.should be_empty
    end
  end
  
  describe "when full" do
    before(:each) do
      (1..10).each {|n| @stack.push n}
    end
    it "should description" do
      @stack.should be_full
    end
  end  
end