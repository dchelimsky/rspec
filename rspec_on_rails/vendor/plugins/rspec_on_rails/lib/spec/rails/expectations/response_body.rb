module Spec
  module Rails
    module Expectations
      class ResponseBody #:nodoc:
        def initialize(response_body)
          @response_body = response_body
        end

        include TagExpectations
        include RjsExpectations
      end
    end
  end
end