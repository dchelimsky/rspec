module Spec
  module Expectations
    module Matchers

      class BeClose #:nodoc:
        def initialize(expected, delta)
          @expected = expected
          @delta = delta
        end
        def matches?(actual)
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