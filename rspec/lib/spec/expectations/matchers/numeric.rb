module Spec
  module Expectations
    module Matchers
      module Numeric
        def be_close(expected, delta)
          BeClose.new(expected, delta)
        end
      
        class BeClose
          def initialize(expected, delta)
            @expected = expected
            @delta = delta
          end
          def met_by?(actual)
            @actual = actual
            (@actual - @expected).abs < @delta
          end
          def failure_message
            "expected #{@expected} +/- (<#{@delta}), but got #{@actual}"
          end
        end
      end
    end
  end
end