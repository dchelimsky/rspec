module Spec
  module RailsPlugin
    class ResponseBody < String
      include TagExpectations
      include RjsExpectations
    end
  end
end