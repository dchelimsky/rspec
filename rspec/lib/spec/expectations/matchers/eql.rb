module Spec
  module Expectations
    module Matchers
    
      class Eql #:nodoc:
        def initialize(expected)
          @expected = expected
        end
    
        def matches?(actual)
          @actual = actual
          @actual.eql?(@expected)
        end

        def failure_message
          return "expected #{@expected.inspect}, got #{@actual.inspect} (using .eql?)", @expected, @actual
        end
        
        def negative_failure_message
          return "expected #{@actual.inspect} not to equal #{@expected.inspect} (using .eql?)", @expected, @actual
        end
      end
      
    end
  end
end