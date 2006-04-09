module Spec

  class ShouldHelper < ShouldBase

	  def initialize(target)
	  	@target = target
		end
		
		def not
		  ShouldNegator.new(@target)
		end
    
    def have(expected_number=nil)
      HaveHelper.new(@target, expected_number)
    end
	
		def satisfy(&block)
		  return if block.call(@target)
      fail_with_message "Supplied expectation was not satisfied"
    end
				
	  def equal(expected)
    	fail_with_message(default_message("should equal", expected)) unless (@target == expected)
    end

    def be(expected = :___no_arg)
      return self if (expected == :___no_arg)
      return if (expected == false and @target.nil?)
			return if (expected == true and (!@target.nil?) and (@target != false))
    	fail_with_message(default_message("should be", expected)) unless (@target.equal?(expected))
    end

		def a
			self
		end
		
		alias an a
		
		def instance
			InstanceHelper.new(@target)
		end
		
		def kind
			KindHelper.new(@target)
		end
		
		def respond
			RespondHelper.new(@target)
		end
		
    def method_missing(sym, *args)
      return if @target.send("#{sym}?", *args)
      fail_with_message(default_message("should be #{sym}" + (args.empty? ? '' : (' ' + args.join(', ')))))
    end

    def match(expected)
     	fail_with_message(default_message("should match", expected)) unless (@target =~ expected)
    end

    def include(sub)
	    fail_with_message(default_message("should include", sub)) unless (@target.include? sub)
    end
    
    def raise(exception=Exception)
      begin
        @target.call
        fail_with_message(default_message("should raise", exception.inspect))
      rescue exception
      rescue
        fail_with_message(default_message("should raise", exception.inspect))
      end
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