require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/stack'

describe Stack do
  before(:each) do
    @stack = Stack.new
  end
  
  describe "when empty" do
    it "should be empty" do
      @stack.should be_empty
    end
  end
  
  describe "when not empty" do
    describe "- when almost full" do
      before(:each) do
        (1..9).each {|n| @stack.push n}
      end
      it "should not be full" do
        @stack.should_not be_full
      end
    end
    
    describe "- when full" do
      before(:each) do
        (1..10).each {|n| @stack.push n}
      end
      it "should be full" do
        @stack.should be_full
      end
    end  
  end
  
end

