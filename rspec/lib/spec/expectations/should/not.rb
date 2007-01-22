module Spec
  module Expectations
    module Should
      
      class Not < Base
        def initialize(target)
          @target = target
          @be_seen = false
        end

        def be(expected = :no_arg)
          @be_seen = true
          return self if (expected == :no_arg)
          fail_with_message(default_message("should not be", expected)) if (@target.equal?(expected))
        end

        def have(expected_number=nil)
          NotHave.new(@target, :exactly, expected_number)
        end

        def change(receiver, message)
          NotChange.new(@target, receiver, message)
        end
  
        def raise(exception=Exception, message=nil)
          begin
            @target.call
          rescue exception => e
            return unless message.nil? || e.message == message || (message.is_a?(Regexp) && e.message =~ message)
            fail_with_message("#{default_message("should not raise", exception)}") if e.instance_of? exception
            fail_with_message("#{default_message("should not raise", exception)} but raised #{e.inspect}") unless e.instance_of? exception
          rescue
            true
          end
        end
    
        def throw(symbol=:___this_is_a_symbol_that_will_likely_never_occur___)
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

        def __delegate_method_missing_to_target original_sym, actual_sym, *args
          return unless @target.__send__(actual_sym, *args)
          fail_with_message(default_message("should not#{@be_seen ? ' be' : ''} #{original_sym}" + (args.empty? ? '' : ' ' + args[0].inspect)))
        end
      end

    end
  end
end
