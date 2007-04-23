module Spec
  module DSL
    class CompositeProcBuilder < Array
      # TODO - is this necessary for anything other than a spec?
      attr_reader :parent

      def initialize(parent)
        @parent = parent
      end

      def call
        proc.call
      end

      def add_instance_method_from(source, method_name)
        push(source.instance_method(method_name)) if source.instance_methods.include?(method_name.to_s)
      end

      def proc
        parts = self
        Proc.new do
          parts.collect do |part|
            if part.is_a?(UnboundMethod)
              part.bind(self).call
            else
              instance_eval(&part)
            end
          end
        end
      end
    end
  end
end
