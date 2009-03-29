module Spec
  module Matchers
    
    class BeClose
      def initialize(expected, delta)
        @expected, @delta = expected, delta
      end
      
      def matches?(actual)
        @actual = actual
        (@actual - @expected).abs < @delta
      end
      
      def failure_message_for_should
        "expected #{@expected} +/- (< #{@delta}), got #{@actual}"
      end
      
      def description
        "be close to #{@expected} (within +- #{@delta})"
      end
    end

    # :call-seq:
    #   should be_close(expected, delta)
    #   should_not be_close(expected, delta)
    #
    # Passes if actual == expected +/- delta
    #
    # == Example
    #
    #   result.should be_close(3.0, 0.5)
    def be_close(expected, delta)
      BeClose.new(expected, delta)
    end
  end
end
