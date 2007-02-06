module Spec
  module Expectations
    module Matchers
      
      class Satisfy #:nodoc:
        def initialize(&block)
          @block = block
        end
        
        def matches?(actual, &block)
          @block = block if block
          @actual = actual
          @block.call(actual)
        end
        
        def failure_message
          "expected #{@actual} to satisfy block"
        end

        def negative_failure_message
          "expected #{@actual} not to satisfy block"
        end
      end
      
    end
  end
end
