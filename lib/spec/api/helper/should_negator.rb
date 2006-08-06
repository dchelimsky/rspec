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
      @be_seen = true
      return self if (expected == :no_arg)
      fail_with_message(default_message("should not be", expected)) if (@target.equal?(expected))
    end

    def an_instance_of expected_class
      fail_with_message(default_message("should not be an instance of", expected_class)) if @target.instance_of? expected_class
    end
    
    def a_kind_of expected_class
      fail_with_message(default_message("should not be a kind of", expected_class)) if @target.kind_of? expected_class
    end

    def respond_to message
      fail_with_message(default_message("should not respond to", message)) if @target.respond_to? message
    end
    
    def match(expected)
        fail_with_message(default_message("should not match", expected)) if (@target =~ expected)
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
      fail_with_message(default_message("should not #{sym}" + (args.empty? ? '' : (' ' + args.join(', '))))) unless @be_seen
      fail_with_message(default_message("should not be #{sym}" + (args.empty? ? '' : (' ' + args.join(', '))))) if @be_seen
    end

  end

end