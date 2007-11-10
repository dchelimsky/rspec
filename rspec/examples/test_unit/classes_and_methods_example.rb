require File.dirname(__FILE__) + '/../pure/spec_helper'
require File.dirname(__FILE__) + '/../pure/stack'

class EmptyStackSpec < Spec::ExampleGroup
  def should_be_empty
    stack = Stack.new
    
    # you can use an assertion ...
    assert stack.empty?
    
    # ... or an expectation
    stack.should be_empty
  end
  
  def should_not_be_empty_after_push
    stack = Stack.new
    stack.push 'foo'

    # you can use an assertion ...
    assert !stack.empty?
    
    # ... or an expectation
    stack.should_not be_empty
  end
end