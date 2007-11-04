require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + "/stack"

class EmptyStackSpec < Spec::ExampleGroup
  def should_be_empty
    stack = Stack.new
    assert stack.empty?
  end
  
  def should_not_be_empty_after_push
    stack = Stack.new
    stack.push 'foo'
    assert !stack.empty?
  end
end