module Spec
  
  class ShouldNegator < ShouldBase
    
    def initialize(target)
      @target = target
    end
  
    def satisfy
      fail_with_message "Supplied expectation was satisfied, but should not have been" if (yield @target)
    end
        
    def equal(expected)
      fail_with_message(default_message("should not equal", expected)) if (@target == expected)
    end
    
    def be(expected = :no_arg)
      return self if (expected == :no_arg)
      fail_with_message(default_message("should not be", expected)) if (@target.equal?(expected))
    end

    def a
      self
    end
    
    alias an a
    
    def instance
      InstanceNegator.new(@target)
    end
    
    def kind
      KindNegator.new(@target)
    end

      def respond
        RespondNegator.new(@target)
      end
    
    def match(expected)
        fail_with_message(default_message("should not match", expected)) if (@target =~ expected)
    end
    
    def include(sub)
        fail_with_message(default_message("should not include", sub)) if (@target.include? sub)
    end
   
    def raise(exception=Exception, message=nil)
      begin
        @target.call
      rescue exception => e
        return unless message.nil? || e.message == message
        fail_with_message("#{default_message("should not raise", exception)}") if e.instance_of? exception
        fail_with_message("#{default_message("should not raise", exception)} but raised #{e.inspect}") unless e.instance_of? exception
      rescue
        true
      end
    end
    
    def throw(symbol=:___this_is_a_symbol_that_will_never_occur___)
      begin
        catch symbol do
          @target.call
          return true
        end
        fail_with_message(default_message("should not throw", symbol.inspect))
      rescue NameError
        true
      end
    end

    def method_missing(sym, *args)
      return unless @target.send("#{sym}?", *args)
      fail_with_message(default_message("should not be #{sym}" + (args.empty? ? '' : (' ' + args.join(', ')))))
    end

  end

end