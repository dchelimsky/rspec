module Spec
  module Rails
    class ResponseBody < String
      include TagExpectations
      include RjsExpectations
    end
  end
end