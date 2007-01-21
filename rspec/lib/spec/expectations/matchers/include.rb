module Spec
  module Expectations
    module Matchers

      class Include #:nodoc:
        
        def initialize(expected)
          @expected = expected
        end
        
        def matches?(actual)
          @actual = actual
          actual.include?(@expected)
        end
        
        def failure_message
          _message
        end
        
        def negative_failure_message
          _message("not ")
        end
        
        private
          def _message(maybe_not="")
            "expected #{@actual.inspect} to #{maybe_not}include #{@expected.inspect}"
          end
      end

    end
  end
end
