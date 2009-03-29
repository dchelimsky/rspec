module Spec
  module Matchers

    class Exist
      def matches?(actual)
        @actual = actual
        actual.exist?
      end

      def failure_message_for_should
        "expected #{@actual.inspect} to exist, but it doesn't."
      end

      def failure_message_for_should_not
        "expected #{@actual.inspect} to not exist, but it does."
      end

      def description
        "exists"
      end
    end

    # :call-seq:
    #   should exist
    #   should_not exist
    #
    # Passes if actual.exist?
    def exist
      Exist.new
    end
  end
end
