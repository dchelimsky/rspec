module Spec
  module Expectations
    module Matchers
      
      class Match #:nodoc:
        def initialize(expected)
          @expected = expected
        end
        
        def met_by?(actual)
          @actual = actual
          return true if actual =~ @expected
          return false
        end
        
        def failure_message
          "expected #{@actual.inspect} to match #{@expected.inspect}"
        end
        
        def negative_failure_message
          "expected #{@actual.inspect} to not match #{@expected.inspect}"
        end
      end
      
    end
  end
end
