class Stack
  def empty?
    @item.nil?
  end
  def push item
    @item = item
  end
  def top
     @item
  end
end
