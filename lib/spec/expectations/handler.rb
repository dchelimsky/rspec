module Spec
  module Expectations
    class InvalidMatcherError < ArgumentError; end        
    
    class ExpectationMatcherHandler        
      def self.handle_matcher(actual, matcher, &block)
        ::Spec::Matchers.last_should = :should
        ::Spec::Matchers.last_matcher = matcher
        return ::Spec::Matchers::PositiveOperatorMatcher.new(actual) if matcher.nil?

        match = matcher.matches?(actual, &block)
        return match if match

        ::Spec::Expectations.fail_with matcher.respond_to?(:failure_message_for_should) ?
                                       matcher.failure_message_for_should :
                                       matcher.failure_message
      end
    end

    class NegativeExpectationMatcherHandler
      def self.handle_matcher(actual, matcher, &block)
        ::Spec::Matchers.last_should = :should_not
        ::Spec::Matchers.last_matcher = matcher

        return ::Spec::Matchers::NegativeOperatorMatcher.new(actual) if matcher.nil?
        
        match = matcher.respond_to?(:does_not_match?) ?
                !matcher.does_not_match?(actual, &block) :
                matcher.matches?(actual, &block)
        return match unless match

        ::Spec::Expectations.fail_with matcher.respond_to?(:failure_message_for_should_not) ?
                                       matcher.failure_message_for_should_not :
                                       matcher.negative_failure_message
      end
    end
  end
end

