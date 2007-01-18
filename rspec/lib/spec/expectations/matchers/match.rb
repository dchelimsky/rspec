module Spec
  module Expectations
    module Matchers
      class Match
        def initialize(expected)
          @expected = expected
        end
        
        def met_by?(target)
          @target = target
          return true if target =~ @expected
          return false
        end
        
        def failure_message
          "expected #{@target.inspect} to match #{@expected.inspect}"
        end
        
        def negative_failure_message
          "expected #{@target.inspect} to not match #{@expected.inspect}"
        end
      end
    end
  end
end
