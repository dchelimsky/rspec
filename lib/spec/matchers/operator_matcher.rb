module Spec
  module Matchers
    class BaseOperatorMatcher
      attr_reader :generated_description
      
      def initialize(given)
        @given = given
      end

      def ==(expected)
        @expected = expected
        __delegate_method_missing_to_given("==", expected)
      end

      def ===(expected)
        @expected = expected
        __delegate_method_missing_to_given("===", expected)
      end

      def =~(expected)
        @expected = expected
        __delegate_method_missing_to_given("=~", expected)
      end

      def >(expected)
        @expected = expected
        __delegate_method_missing_to_given(">", expected)
      end

      def >=(expected)
        @expected = expected
        __delegate_method_missing_to_given(">=", expected)
      end

      def <(expected)
        @expected = expected
        __delegate_method_missing_to_given("<", expected)
      end

      def <=(expected)
        @expected = expected
        __delegate_method_missing_to_given("<=", expected)
      end

      def fail_with_message(message)
        Spec::Expectations.fail_with(message, @expected, @given)
      end
      
      def description
        "#{@operator} #{@expected.inspect}"
      end

    end

    class PositiveOperatorMatcher < BaseOperatorMatcher #:nodoc:

      def __delegate_method_missing_to_given(operator, expected)
        @operator = operator
        ::Spec::Matchers.last_matcher = self
        return true if @given.__send__(operator, expected)
        return fail_with_message("expected: #{expected.inspect},\n     got: #{@given.inspect} (using #{operator})") if ['==','===', '=~'].include?(operator)
        return fail_with_message("expected: #{operator} #{expected.inspect},\n     got: #{operator.gsub(/./, ' ')} #{@given.inspect}")
      end

    end

    class NegativeOperatorMatcher < BaseOperatorMatcher #:nodoc:

      def __delegate_method_missing_to_given(operator, expected)
        @operator = operator
        ::Spec::Matchers.last_matcher = self
        return true unless @given.__send__(operator, expected)
        return fail_with_message("expected not: #{operator} #{expected.inspect},\n         got: #{operator.gsub(/./, ' ')} #{@given.inspect}")
      end

    end

  end
end
