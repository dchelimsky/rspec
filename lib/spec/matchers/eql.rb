module Spec
  module Matchers
  
    class Eql #:nodoc:
      def initialize(expected)
        @expected = expected
      end
  
      def matches?(given)
        @given = given
        @given.eql?(@expected)
      end

      def failure_message
        return "expected #{@expected.inspect}, got #{@given.inspect} (using .eql?)", @expected, @given
      end
      
      def negative_failure_message
        return "expected #{@given.inspect} not to equal #{@expected.inspect} (using .eql?)", @expected, @given
      end

      def description
        "eql #{@expected.inspect}"
      end
    end
    
    # :call-seq:
    #   should eql(expected)
    #   should_not eql(expected)
    #
    # Passes if given and expected are of equal value, but not necessarily the same object.
    #
    # See http://www.ruby-doc.org/core/classes/Object.html#M001057 for more information about equality in Ruby.
    #
    # == Examples
    #
    #   5.should eql(5)
    #   5.should_not eql(3)
    def eql(expected)
      Matchers::Eql.new(expected)
    end
  end
end
