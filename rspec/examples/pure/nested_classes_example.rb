require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/stack'

class StackExamples < Spec::ExampleGroup
  describe(Stack)
  before(:each) do
    @stack = Stack.new
  end
end

class EmptyStackExamples < StackExamples
  describe("when empty")
  it "should be empty" do
    @stack.should be_empty
  end
end

class NonEmptyStackExamples < StackExamples
end

class AlmostFullStackExamples < NonEmptyStackExamples
  describe("when almost full")
  before(:each) do
    (1..9).each {|n| @stack.push n}
  end
  it "should be full" do
    @stack.should_not be_full
  end
end

class FullStackExamples < NonEmptyStackExamples
  describe("when full")
  before(:each) do
    (1..10).each {|n| @stack.push n}
  end
  it "should be full" do
    @stack.should be_full
  end
end

# TODO
# The output from this should read:
# 
# Stack when empty
# - should be empty
# 
# Stack when almost full
# - should not be full
# 
# Stack when full
# - should be full
