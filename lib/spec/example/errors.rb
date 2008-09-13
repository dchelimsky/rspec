module Spec
  module Example
    class PendingError < StandardError; end
    
    class ExamplePendingError < PendingError; end

    class PendingExampleFixedError < PendingError; end
  end
end
