module Spec
  module Rails
    class HelperContext < Rails::Context
      module ContextEvalClassMethods
        def helper_name(name=nil)
          send :include, "#{name}_helper".camelize.constantize
        end
      end
      def before_context_eval
        inherit Spec::Rails::HelperEvalContext
        @context_eval_module.extend HelperContext::ContextEvalClassMethods
      end
    end
  end
end

