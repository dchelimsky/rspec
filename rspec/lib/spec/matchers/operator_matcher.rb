module Spec
  module Matchers
    class BaseOperatorMatcher
      
      def ==(expected)
        __delegate_method_missing_to_target "==", expected
      end

      def =~(expected)
        __delegate_method_missing_to_target "=~", expected
      end

      def default_message(expectation, expected)
        return "expected #{expected.inspect}, got #{@target.inspect} (using #{expectation})" if expectation == '=='
        "expected #{expectation} #{expected.inspect}, got #{@target.inspect}" unless expectation == '=='
      end

      def fail_with_message(message, expected=nil, target=nil)
        Spec::Expectations.fail_with(message, expected, target)
      end

    end

    class PositiveOperatorMatcher < BaseOperatorMatcher

      def initialize(target, expectation=nil)
        @target = target
      end

    private

      def __delegate_method_missing_to_target(operator, expected)
        ::Spec::Matchers.generated_description = "should #{operator} #{expected.inspect}"
        return if @target.send(operator, expected)
        fail_with_message(default_message(operator, expected), expected, @target)
      end

    end

    class NegativeOperatorMatcher < BaseOperatorMatcher #:nodoc:

      def initialize(target)
        @target = target
      end

    private 

      def __delegate_method_missing_to_target operator, expected
        ::Spec::Matchers.generated_description = "should not #{operator} #{expected.inspect}"
        return unless @target.__send__(operator, expected)
        fail_with_message(default_message("not #{operator}", expected))
      end

    end

  end
end
