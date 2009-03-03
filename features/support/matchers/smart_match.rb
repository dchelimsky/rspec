module Spec
  module Matchers
    class SmartMatch
      def initialize(expected)
        @expected = expected
      end

      def matches?(actual)
        @actual = actual
        # Satisfy expectation here. Return false or raise an error if it's not met.

        if @expected =~ /^\/.*\/?$/ || @expected =~ /^".*"$/
          regex_or_string = eval(@expected)
          if Regexp === regex_or_string
            (@actual =~ regex_or_string) ? true : false
          else
            @actual.index(regex_or_string) != nil
          end
        else
          false
        end
      end

      def failure_message
        "expected #{@actual} to smart_match #{@expected}"
      end

      def negative_failure_message
        "expected #{@actual} not to smart_match #{@expected}"
      end
    end

    def smart_match(expected)
      SmartMatch.new(expected)
    end
  end
end