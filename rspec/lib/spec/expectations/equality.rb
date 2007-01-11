module Spec
  module Expectations
    module EqualityExpectations
      #passes if receiver.equal?(expected)
      def equal(other)
        Equal.new(other)
      end
      #passes if receiver.eql?(expected)
      def eql(other)
        Eql.new(other)
      end
      #passes if !(receiver.equal?(expected))
      def not_equal(other)
        NotEqual.new(other)
      end
      #passes if !(receiver.eql?(expected))
      def not_eql(other)
        NotEql.new(other)
      end
    end
    
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
    end

    class NotEqual #:nodoc:
      def initialize(expected)
        @expected = expected
      end
      
      def met_by?(actual)
        @actual = actual
        !@actual.equal?(@expected)
      end

      def failure_message
        "expected #{@actual.inspect} to not equal #{@expected.inspect} (using .equal?)"
      end
    end

    class NotEql #:nodoc:
      def initialize(expected)
        @expected = expected
      end
      
      def met_by?(actual)
        @actual = actual
        !@actual.eql?(@expected)
      end

      def failure_message
        "expected #{@actual.inspect} to not equal #{@expected.inspect} (using .eql?)"
      end
    end

  end
end