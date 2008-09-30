module Spec
  module Matchers

    class BeClose #:nodoc:
      def initialize(expected, delta)
        @expected = expected
        @delta = delta
      end
      
      def matches?(given)
        @given = given
        (@given - @expected).abs < @delta
      end
      
      def failure_message
        "expected #{@expected} +/- (< #{@delta}), got #{@given}"
      end
      
      def description
        "be close to #{@expected} (within +- #{@delta})"
      end
    end
    
    # :call-seq:
    #   should be_close(expected, delta)
    #   should_not be_close(expected, delta)
    #
    # Passes if given == expected +/- delta
    #
    # == Example
    #
    #   result.should be_close(3.0, 0.5)
    def be_close(expected, delta)
      Matchers::BeClose.new(expected, delta)
    end
  end
end
