require 'spec'
require 'movie'
require 'movie_list'

class EmptyMovieList < Spec::Context

  def setup
    @list = MovieList.new
  end
    
  def should_have_size_of_0
    @list.size.should.equal 0
  end
  
  def should_not_include_star_wars
    @list.should.not.include "Star Wars"
  end
  
end

class OneMovieList < Spec::Context

  def setup
    @list = MovieList.new
    star_wars = Movie.new "Star Wars"
    @list.add star_wars
  end
  
  def should_have_size_of_1
    @list.size.should.equal 1
  end
  
  def should_include_star_wars
    @list.should.include "Star Wars"
  end
  
end