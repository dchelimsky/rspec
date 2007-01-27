module Spec
  module Expectations
    module Matchers
      class Have
        alias_method :__original_failure_message, :failure_message
        def failure_message
          return __original_failure_message unless @sym == :errors_on
          "expected #{relativities[@relativity]}#{@expected} errors on :#{@args[0]}, got #{@actual}"
        end
      end
    end
  end
end