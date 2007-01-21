module Spec
  module Expectations
    class ExpectationMatcherHandler

      def initialize(actual, matcher)
        unless matcher.nil?
          unless matcher.matches?(actual)
            Spec::Expectations.fail_with(matcher.failure_message)
          end
        end
      end

    end

    class NegativeExpectationMatcherHandler
    
      def initialize(actual, matcher)
        unless matcher.nil?
          if matcher.matches?(actual)
            Spec::Expectations.fail_with(matcher.negative_failure_message)
          end
        end
      end
    
    end

  end
end

