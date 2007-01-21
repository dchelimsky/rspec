module Spec
  module Expectations
    module Matchers

      class BeClose #:nodoc:
        def initialize(expected, delta)
          @expected = expected
          @delta = delta
        end
        def met_by?(actual)
          @actual = actual
          (@actual - @expected).abs < @delta
        end
        def failure_message
          "expected #{@expected} +/- (<#{@delta}), got #{@actual}"
        end
      end

    end
  end
end