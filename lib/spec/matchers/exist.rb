module Spec
  module Matchers
    class Exist
      def matches?(given)
        @given = given
        @given.exist?
      end
      def failure_message
        "expected #{@given.inspect} to exist, but it doesn't."
      end
      def negative_failure_message
        "expected #{@given.inspect} to not exist, but it does."
      end
    end
    # :call-seq:
    #   should exist
    #   should_not exist
    #
    # Passes if given.exist?
    def exist; Exist.new; end
  end
end
