module Spec
  module Expectations
    
    class ExpectationMatcherHandler

      def self.handle_matcher(actual, matcher, &block)
        unless matcher.nil?
          match = matcher.matches?(actual, &block)
          ::Spec::Expectations::Matchers.generated_name = "should #{matcher.to_s}"
          Spec::Expectations.fail_with(matcher.failure_message) unless match
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
          match = matcher.matches?(actual, &block)
          ::Spec::Expectations::Matchers.generated_name = "should not #{matcher.to_s}"
          Spec::Expectations.fail_with(matcher.negative_failure_message) if match
        end
      end
    
    end

  end
end

