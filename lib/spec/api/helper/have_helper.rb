module Spec

  class HaveHelper < ShouldBase

    def initialize(target, expected=nil)
      @target = target
      @expected = expected == :no ? 0 : expected
      @min = false
      @max = false
    end
    
    def method_missing(sym, *args)
      fail_with_message(build_message(sym)) unless as_specified?(sym)
    end
    
    def collection(sym)
      @target.send(sym)
    end
    
    def actual_size(collection)
      return collection.length if collection.respond_to? :length
      return collection.size if collection.respond_to? :size
    end
    
    def build_message(sym)
      message = "<#{@target.class.to_s}> should have"
      message += " at least" if @min
      message += " at most" if @max
      message += " #{@expected} #{sym} (has #{actual_size(collection(sym))})"
    end
    
    def as_specified?(sym)
      return actual_size(collection(sym)) >= @expected if @min
      return actual_size(collection(sym)) <= @expected if @max
      return actual_size(collection(sym)) == @expected
    end

    def at
      self
    end
    
    def least(min)
      @expected = min
      @min = true
      self
    end
    
    def most(max)
      @expected = max
      @max = true
      self
    end

  end

end