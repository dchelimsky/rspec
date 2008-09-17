module Spec
  module Example
    class ExamplePendingError < StandardError
      def initialize(a_message=nil)
        super
        @pending_caller = caller[2]
      end
      
      attr_reader :pending_caller
    end

    class PendingExampleFixedError < StandardError
    end
  end
end
