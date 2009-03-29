module Spec
  module Matchers
    class BeKindOf
      def initialize(expected)
        @expected = expected
      end
      
      def matches?(actual)
        @actual = actual
        @actual.kind_of?(@expected)
      end
      
      def description
        "be a kind of #{@expected}"
      end
      
      def failure_message_for_should
        "expected kind of #{@expected}, got #{@actual.inspect}"
      end
      
      def failure_message_for_should_not
        "expected #{@actual.inspect} not to be a kind of #{@expected}"
      end
    end

    # :call-seq:
    #   should be_kind_of(expected)
    #   should be_a_kind_of(expected)
    #   should_not be_kind_of(expected)
    #   should_not be_a_kind_of(expected)
    #
    # Passes if actual.kind_of?(expected)
    #
    # == Examples
    #
    #   5.should be_kind_of(Fixnum)
    #   5.should be_kind_of(Numeric)
    #   5.should_not be_kind_of(Float)
    def be_kind_of(expected)
      BeKindOf.new(expected)
    end
    
    alias_method :be_a_kind_of, :be_kind_of
  end
end
