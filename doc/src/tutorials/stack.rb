class StackUnderflowError < RuntimeError
end

class Stack
  
  def push item
    @item = item
  end
  
  def top
    raise StackUnderflowError if @item.nil?
    @item
  end
  
  def pop
    raise StackUnderflowError if @item.nil?
    item = @item
    @item = nil
    item
  end
  
end