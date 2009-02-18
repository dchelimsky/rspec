module Spec
  module Matchers
    class BeKindOf
      def initialize(expected)
        @expected = expected
      end
      
      def matches?(actual)
        @actual = actual.class
        @actual == @expected
      end
      
      def description
        "be kind of"
      end
      
      def failure_message
        "expected to be kind of #@expected, but actually was kind of #{@actual}"
      end
      
      def negative_failure_message
        "expected not to be kind of #@actual, but was"
      end
    end

    def be_kind_of(expected)
      BeKindOf.new(expected)
    end
  end
end
