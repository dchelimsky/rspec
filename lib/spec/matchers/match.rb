module Spec
  module Matchers
    
    class Match #:nodoc:
      def initialize(regexp)
        @regexp = regexp
      end
      
      def matches?(given)
        @given = given
        return true if given =~ @regexp
        return false
      end
      
      def failure_message
        return "expected #{@given.inspect} to match #{@regexp.inspect}", @regexp, @given
      end
      
      def negative_failure_message
        return "expected #{@given.inspect} not to match #{@regexp.inspect}", @regexp, @given
      end
      
      def description
        "match #{@regexp.inspect}"
      end
    end
    
    # :call-seq:
    #   should match(regexp)
    #   should_not match(regexp)
    #
    # Given a Regexp, passes if given =~ regexp
    #
    # == Examples
    #
    #   email.should match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
    def match(regexp)
      Matchers::Match.new(regexp)
    end
  end
end
