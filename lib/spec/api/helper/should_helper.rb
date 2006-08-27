module Spec

  class ShouldHelper < ShouldBase

    def initialize(target)
      @target = target
      @be_seen = false
    end
    
    def not
      ShouldNegator.new(@target)
    end
    
    def have(expected_number=nil)
      HaveHelper.new(@target, :exactly, expected_number)
    end
  
    def have_exactly(expected_number=nil)
      HaveHelper.new(@target, :exactly, expected_number)
    end
  
    def have_at_least(expected_number=nil)
      HaveHelper.new(@target, :at_least, expected_number)
    end
  
    def have_at_most(expected_number=nil)
      HaveHelper.new(@target, :at_most, expected_number)
    end
  
    def satisfy(&block)
      return if block.call(@target)
      fail_with_message "Supplied expectation was not satisfied"
    end
        
    def equal(expected)
      fail_with_message(default_message("should equal", expected)) unless (@target == expected)
    end

    def be(expected = :___no_arg)
      @be_seen = true
      return self if (expected == :___no_arg)
      return if (expected == false and @target.nil?)
      return if (expected == true and (!@target.nil?) and (@target != false))
      fail_with_message(default_message("should be", expected)) unless (@target.equal?(expected))
    end

    def an_instance_of expected_class
      fail_with_message(default_message("should be an instance of", expected_class)) unless @target.instance_of? expected_class
    end
    
    def a_kind_of expected_class
      fail_with_message(default_message("should be a kind of", expected_class)) unless @target.kind_of? expected_class
    end
    
    def respond_to message
      fail_with_message(default_message("should respond to", message)) unless @target.respond_to? message
    end
    
    def method_missing(sym, *args)
      return if @target.send("#{sym}?", *args)
      fail_with_message(default_message("should be #{sym}" + (args.empty? ? '' : (' ' + args.join(', '))))) if @be_seen
      fail_with_message(default_message("should #{sym}" + (args.empty? ? '' : (' ' + args.join(', '))))) unless @be_seen
    end

    def match(expected)
       fail_with_message(default_message("should match", expected)) unless (@target =~ expected)
    end

    def raise(exception=Exception, message=nil)
      begin
        @target.call
      rescue exception => e
        e.message.should_equal message unless message.nil?
        return
      rescue => e
        fail_with_message("#{default_message("should raise", exception)} but raised #{e.inspect}")
      end
      fail_with_message("#{default_message("should raise", exception)} but raised nothing")
    end
    
    def throw(symbol)
      begin
        catch symbol do
          @target.call
          fail_with_message(default_message("should throw", symbol.inspect))
        end
      rescue NameError
        fail_with_message(default_message("should throw", symbol.inspect))
      end
    end

  end
end