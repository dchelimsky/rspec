module Spec
  module Expectations
    module Matchers
      
      class Match #:nodoc:
        def initialize(expected)
          @expected = expected
        end
        
        def matches?(actual)
          @actual = actual
          return true if actual =~ @expected
          return false
        end
        
        def failure_message
          return "expected #{@actual.inspect} to match #{@expected.inspect}", @expected, @actual
        end
        
        def negative_failure_message
          return "expected #{@actual.inspect} not to match #{@expected.inspect}", @expected, @actual
        end
      end
      
    end
  end
end
