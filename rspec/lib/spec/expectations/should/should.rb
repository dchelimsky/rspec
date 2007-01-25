module Spec
  module Expectations
    module Should # :nodoc:

      class Should < Base

        def initialize(target, expectation=nil)
          @target = target
          @be_seen = false
        end
        
        #Gone for 0.9
        def not
          Not.new(@target)
        end
            
        #Gone for 0.9
        def be(expected = :___no_arg)
          @be_seen = true
          return self if (expected == :___no_arg)
          fail_with_message(default_message("should be", expected)) unless (@target.equal?(expected))
        end

        #Gone for 0.9
        def have(expected_number=nil)
          Have.new(@target, :exactly, expected_number)
        end

        #Gone for 0.9
        def change(receiver=nil, message=nil, &block)
          Change.new(@target, receiver, message, &block)
        end

        #Gone for 0.9
        def raise(exception=Exception, message=nil)
          begin
            @target.call
          rescue exception => e
            unless message.nil?
              if message.is_a?(Regexp)
                e.message.should =~ message
              else
                e.message.should == message
              end
            end
            return
          rescue => e
            fail_with_message("#{default_message("should raise", exception)} but raised #{e.inspect}")
          end
          fail_with_message("#{default_message("should raise", exception)} but raised nothing")
        end
  
        #Gone for 0.9
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

        def __delegate_method_missing_to_target(original_sym, actual_sym, *args)
          return if @target.send(actual_sym, *args)
          message = default_message("should#{@be_seen ? ' be' : ''} #{original_sym}", args[0])
          fail_with_message(message)
        end
      end

    end
  end
end
