module Spec
  module Matchers
    class BeInstanceOf
      def initialize(expected)
        @expected = expected
      end
      
      def matches?(actual)
        @actual = actual
        @actual.instance_of?(@expected)
      end
      
      def description
        "be an instance of #{@expected}"
      end
      
      def failure_message_for_should
        "expected instance of #{@expected}, got #{@actual.inspect}"
      end
      
      def failure_message_for_should_not
        "expected #{@actual.inspect} not to be an instance of #{@expected}"
      end
    end

    # :call-seq:
    #   should be_instance_of(expected)
    #   should be_an_instance_of(expected)
    #   should_not be_instance_of(expected)
    #   should_not be_an_instance_of(expected)
    #
    # Passes if actual.instance_of?(expected)
    #
    # == Examples
    #
    #   5.should be_instance_of(Fixnum)
    #   5.should_not be_instance_of(Numeric)
    #   5.should_not be_instance_of(Float)
    def be_instance_of(expected)
      BeInstanceOf.new(expected)
    end
    
    alias_method :be_an_instance_of, :be_instance_of
  end
end
