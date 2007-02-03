module Spec
  module Rails
    module Matchers
      
      class HaveText  #:nodoc:

        def initialize(expected)
          @expected = expected
        end

        def matches?(response)
          @actual = response.body
          case expected
          when Regexp
            actual =~ expected
          else
            actual == expected
          end
        end
        
        def failure_message
          "expected #{expected.inspect}, got #{actual.inspect}"
        end
        
        private
          attr_reader :expected
          attr_reader :actual

      end
      
    end
  end
end
