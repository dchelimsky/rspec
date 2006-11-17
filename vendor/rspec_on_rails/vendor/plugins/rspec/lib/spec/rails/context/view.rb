module Spec
  module Rails
    class ViewContext < Rails::Context
      module ExecutionContextInstanceMethods
        attr_reader :response
        def render(*opts)
          super Rails::OptsMerger.new(opts).merge(:template)
        end
      end
      def execution_context specification=nil
        instance = execution_context_class.new(specification)
        instance.instance_eval { @controller_class_name = "ActionController::Base" }
        instance
      end
      def before_context_eval
        inherit Spec::Rails::ViewEvalContext
        include ExecutionContextInstanceMethods
      end
    end
  end
end

