module Spec
  module Example
    class PendingError < StandardError
      def initialize(a_message=nil)
        super(a_message)
        @pending_caller = caller[2]
      end
      
      attr_reader :pending_caller
    end
    
    class ExamplePendingError < PendingError; end

    class PendingExampleFixedError < PendingError; end
  end
end
