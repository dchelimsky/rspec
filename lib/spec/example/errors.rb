module Spec
  module Example
    class ExamplePendingError < StandardError
      def initialize(a_message=nil)
        super
        @pending_caller = caller[2]
      end
      
      attr_reader :pending_caller
    end
    
    class NotYetImplementedError < ExamplePendingError
      MESSAGE = "Not Yet Implemented"
      RSPEC_ROOT_LIB = File.expand_path(File.dirname(__FILE__) + "/../..")
      
      def initialize(backtrace)
        super(MESSAGE)
        @pending_caller = find_pending_caller(backtrace)
      end
      
    private
      
      def find_pending_caller(backtrace)
        backtrace.detect do |line|
          !line.include?(RSPEC_ROOT_LIB)
        end
      end
    end

    class PendingExampleFixedError < StandardError; end
  end
end
