module Spec #:nodoc:
  module Matchers #:nodoc:
    class Have #:nodoc:
      alias_method :__original_failure_message, :failure_message
      def failure_message
        return "expected #{relativities[@relativity]}#{@expected} errors on :#{@args[0]}, got #{@actual}" if @collection_name == :errors_on
        return "expected #{relativities[@relativity]}#{@expected} error on :#{@args[0]}, got #{@actual}" if @collection_name == :error_on
        return __original_failure_message
      end
    end
  end
end
