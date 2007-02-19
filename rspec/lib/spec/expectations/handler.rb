module Spec
  module Expectations
    
    class ExpectationMatcherHandler

      def self.handle_matcher(actual, matcher, &block)
        unless matcher.nil?
          unless matcher.matches?(actual, &block)
            Spec::Expectations.fail_with(matcher.failure_message)
          end
        end
      end

    end

    class NegativeExpectationMatcherHandler
    
      def self.handle_matcher(actual, matcher, &block)
        unless matcher.nil?
          unless matcher.respond_to?(:negative_failure_message)
            Spec::Expectations.fail_with(
<<-EOF
Matcher does not support should_not.
See Spec::Expectations::Matchers for more information
about matchers.
EOF
)
          end
          if matcher.matches?(actual, &block)
            Spec::Expectations.fail_with(matcher.negative_failure_message)
          end
        end
      end
    
    end

  end
end

