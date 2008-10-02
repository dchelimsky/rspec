module Spec
  module Example
    class ExamplePendingError < StandardError
      def initialize(a_message=nil)
        super
        @pending_caller = caller[2]
      end
      
      attr_reader :pending_caller
    end
    
    class DefaultPendingError < ExamplePendingError
      RSPEC_ROOT_LIB = File.expand_path(File.dirname(__FILE__) + "/../..")
      
      def initialize(call_stack, message = nil)
        super(message)
        @pending_caller = find_pending_caller(call_stack)
      end
      
    private
      
      def find_pending_caller(call_stack)
        call_stack.detect do |trace|
          !trace.include?(RSPEC_ROOT_LIB)
        end
      end
    end

    class PendingExampleFixedError < StandardError; end
  end
end
