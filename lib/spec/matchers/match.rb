module Spec
  module Matchers
    class Match
      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @actual = actual
        actual =~ @expected
      end

      def failure_message_for_should
        return "expected #{@actual.inspect} to match #{@expected.inspect}", @expected, @actual
      end

      def failure_message_for_should_not
        return "expected #{@actual.inspect} not to match #{@expected.inspect}", @expected, @actual
      end

      def description
        "match #{@expected.inspect}"
      end
    end
    
    
    # :call-seq:
    #   should match(regexp)
    #   should_not match(regexp)
    #
    # Given a Regexp, passes if actual =~ regexp
    #
    # == Examples
    #
    #   email.should match(/^([^\s]+)((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
    def match(expected)
      Match.new(expected)
    end
  end
end
