module Spec
  module Rails
    class ModelEvalContext < Spec::Rails::EvalContext
    end
    class ModelContext < Spec::Rails::Context
      def before_context_eval
        inherit_context_eval_module_from Spec::Rails::ModelEvalContext
        @context_eval_module.init_global_fixtures
      end
    end
  end
end

