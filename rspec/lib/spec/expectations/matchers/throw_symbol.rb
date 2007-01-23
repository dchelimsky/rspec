module Spec
  module Expectations
    module Matchers
      
      class ThrowSymbol #:nodoc:
        def initialize(expected=nil)
          @expected = expected
        end
        
        def matches?(proc)
          begin
            catch @expected do
              proc.call
              return false
            end
          rescue => e
            @actual = e
            return false
          end
          return true
        end

        def failure_message
          if @actual
            "expected #{@expected.inspect} thrown, got #{@actual.inspect}"
          else
            "expected #{@expected.inspect} thrown but nothing was thrown"
          end
        end
        
        def negative_failure_message
          "expected #{@expected.inspect} to not be thrown, but it was"
        end
      end
   
    end
  end
end
        
