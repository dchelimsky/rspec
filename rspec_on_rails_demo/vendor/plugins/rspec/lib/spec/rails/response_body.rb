module Spec
  module Rails
    class ResponseBody
      def initialize(response_body)
        @response_body = response_body
      end

      include TagExpectations
      include RjsExpectations
    end
  end
end