module Spec
  module Example      
    module Pending
      def pending(message = "TODO")
        pending_caller = caller[0]
        if block_given?
          begin
            yield
          rescue Exception => e
            raise Spec::Example::ExamplePendingError.new(message, pending_caller)
          end
          raise Spec::Example::PendingExampleFixedError.new("Expected pending '#{message}' to fail. No Error was raised.")
        else
          raise Spec::Example::ExamplePendingError.new(message, pending_caller)
        end
      end
    end
  end
end
