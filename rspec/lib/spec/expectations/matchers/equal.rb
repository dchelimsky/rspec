module Spec
  module Expectations
    module Matchers
    
      class Equal #:nodoc:
        def initialize(expected)
          @expected = expected
        end
    
        def matches?(actual)
          @actual = actual
          @actual.equal?(@expected)
        end

        def failure_message
          return "expected #{@expected.inspect}, got #{@actual.inspect} (using .equal?)", @expected, @actual
        end

        def negative_failure_message
          "expected #{@expected.inspect} not to equal #{@actual.inspect} (using .equal?)"
        end
      end
      
    end
  end
end