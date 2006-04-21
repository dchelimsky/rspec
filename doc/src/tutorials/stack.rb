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
  
end