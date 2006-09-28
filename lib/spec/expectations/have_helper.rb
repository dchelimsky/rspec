module Spec
  module Expectations
    class HaveHelper < ShouldBase

      def initialize(target, relativity=:exactly, expected=nil)
        @target = target
        @expected = expected == :no ? 0 : expected
        @at_least = (relativity == :at_least)
        @at_most = (relativity == :at_most)
      end
    
      def method_missing(sym, *args)
        fail_with_message(build_message(sym, args)) unless as_specified?(sym, args)
      end
    
      def collection(sym, args)
        @target.send(sym, *args)
      end
    
      def actual_size(collection)
        return collection.length if collection.respond_to? :length
        return collection.size if collection.respond_to? :size
      end
    
      def build_message(sym, args)
        message = "#{@target.inspect_for_expectation_not_met_error} should have"
        message += " at least" if @at_least
        message += " at most" if @at_most
        message += " #{@expected} #{sym} (has #{actual_size(collection(sym, args))})"
      end
    
      def as_specified?(sym, args)
        return actual_size(collection(sym, args)) >= @expected if @at_least
        return actual_size(collection(sym, args)) <= @expected if @at_most
        return actual_size(collection(sym, args)) == @expected
      end

    end
  end

end