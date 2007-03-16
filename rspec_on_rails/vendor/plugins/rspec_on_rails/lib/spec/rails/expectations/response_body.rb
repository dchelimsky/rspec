module Spec
  module Rails
    module Expectations
      class ResponseBody #:nodoc:
        def initialize(response_body)
          @response_body = response_body
        end
      end
    end
  end
end