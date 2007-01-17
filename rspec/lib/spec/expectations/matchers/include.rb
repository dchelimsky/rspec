module Spec
  module Expectations
    module Matchers

      class Include
        
        def initialize(expected)
          @expected = expected
        end
        
        def met_by?(target)
          @target = target
          target.include?(@expected)
        end
        
        def failure_message
          _message(true)
        end
        
        def negative_failure_message
          _message(false)
        end
        
        private
          def _message(predicate)
            "expected #{@target.inspect} to #{predicate ? "" : "not "}include #{@expected.inspect}"
          end
      end

    end
  end
end
