module Spec
  module Expectations
    module Matchers
      
      class Satisfy #:nodoc:
        def initialize(&block)
          @block = block
        end
        
        def matches?(actual)
          @actual = actual
          @block.call(actual)
        end
        
        def failure_message
          "expected #{@actual} to satisfy block"
        end

        def negative_failure_message
          "expected #{@actual} to not satisfy block"
        end
      end
      
    end
  end
end
