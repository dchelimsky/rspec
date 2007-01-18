module Spec
  module Expectations
    module Matchers
      class Satisfy
        def initialize(&block)
          @block = block
        end
        
        def met_by?(target)
          @target = target
          @block.call(target)
        end
        
        def failure_message
          "expected #{@target} to satisfy block"
        end

        def negative_failure_message
          "expected #{@target} to not satisfy block"
        end
      end
    end
  end
end
