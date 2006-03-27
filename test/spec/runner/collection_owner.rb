class CollectionWithSizeMethod

  def initialize
    @list = []
  end
  
  def size
    @list.size
  end
  
  def push(item)
    @list.push(item)
  end

end

class CollectionWithLengthMethod

  def initialize
    @list = []
  end
  
  def length
    @list.length
  end

  def push(item)
    @list.push(item)
  end

end

class CollectionOwner
  attr_reader :items_in_collection_with_size_method, :items_in_collection_with_length_method
  
  def initialize
    @items_in_collection_with_size_method = CollectionWithSizeMethod.new
    @items_in_collection_with_length_method = CollectionWithLengthMethod.new
  end
  
  def add_to_collection_with_size_method(item)
    @items_in_collection_with_size_method.push(item)
  end
  
  def add_to_collection_with_length_method(item)
    @items_in_collection_with_length_method.push(item)
  end
end
