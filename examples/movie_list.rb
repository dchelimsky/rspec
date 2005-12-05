class MovieList

  def initialize
    @movies = Hash.new
  end

  def size
    @movies.size
  end

  def add (movieToAdd)
    @movies.store(movieToAdd.name, movieToAdd)
  end

  def include? (aName)
    @movies.include?(aName)
  end
  
end