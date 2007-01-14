module Spec
  module Expectations
    module Matchers
      module Equality
    
        class Equal #:nodoc:
          def initialize(expected)
            @expected = expected
          end
      
          def met_by?(actual)
            @actual = actual
            @actual.equal?(@expected)
          end

          def failure_message
            "expected #{@actual.inspect} to equal #{@expected.inspect} (using .equal?)"
          end

          def negative_failure_message
            "expected #{@actual.inspect} to not equal #{@expected.inspect} (using .equal?)"
          end
        end

        class Eql #:nodoc:
          def initialize(expected)
            @expected = expected
          end
      
          def met_by?(actual)
            @actual = actual
            @actual.eql?(@expected)
          end

          def failure_message
            "expected #{@actual.inspect} to equal #{@expected.inspect} (using .eql?)"
          end
          
          def negative_failure_message
            "expected #{@actual.inspect} to not equal #{@expected.inspect} (using .eql?)"
          end
        end
      
      end
    end
  end
end