module Spec
  module DSL
    class CompositeProcBuilder < Array
      def initialize(callbacks=[])
        push(*callbacks)
      end

      def call(&error_handler)
        proc(&error_handler).call
      end

      def add_instance_method_from(source, method_name)
        push(source.instance_method(method_name)) if source.instance_methods.include?(method_name.to_s)
      end

      def proc(&error_handler)
        parts = self
        Proc.new do
          parts.collect do |part|
            begin
              if part.is_a?(UnboundMethod)
                part.bind(self).call
              else
                instance_eval(&part)
              end
            rescue Exception => e
              raise e unless error_handler
              error_handler.call(e)
              e
            end
          end
        end
      end
    end
  end
end
