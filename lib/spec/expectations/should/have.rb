module Spec
  module Expectations
    module Should
      class Have < Base

        def initialize(target, relativity=:exactly, expected=nil)
          @target = target
          @expected = expected == :no ? 0 : expected
          @at_least = (relativity == :at_least)
          @at_most = (relativity == :at_most)
        end
    
        def exactly(expected_number=nil)
          @at_least = false
          @at_most = false
          @expected = expected_number == :no ? 0 : expected_number
          self
        end

        def at_least(expected_number=nil)
          @at_least = true
          @at_most = false
          @expected = expected_number == :no ? 0 : expected_number
          self
        end

        def at_most(expected_number=nil)
          @at_least = false
          @at_most = true
          @expected = expected_number == :no ? 0 : expected_number
          self
        end

        def method_missing(sym, *args)
          if @target.respond_to?(sym)
            fail_with_message(build_message(sym, args)) unless as_specified?(sym, args)
          elsif @target.respond_to?("has_#{sym}?")
            check_has_sym(sym, *args)
          else
            raise NoMethodError.new("#{@target.inspect} does not respond to `#{sym}' or `has_#{sym}?'")
          end
        end
        
        def check_has_sym(sym, *args)
          return if @target.send("has_#{sym}?", *args)
          fail_with_message msg(sym, args, "should have")
        end
      
        def msg(sym, args, text)
          "#{@target.inspect_for_expectation_not_met_error} #{text} #{sym}: #{args.collect{|arg| arg.inspect_for_expectation_not_met_error}.join(', ')}"
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

        def collection(sym, args)
          @target.send(sym, *args)
        end
      end
      
      class NotHave < Have
        def check_has_sym(sym, *args)
          return unless @target.send("has_#{sym}?", *args)
          fail_with_message msg(sym, args, "should not have")
        end
      end
    end
  end
end
