require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../pure/stack'

class EmptyStackSpec < Spec::ExampleGroup
  def should_be_empty
    stack = Stack.new
    stack.should be_empty
  end
  
  def should_not_be_empty_after_push
    stack = Stack.new
    stack.push 'foo'
    stack.should_not be_empty
  end
end