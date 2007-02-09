module Spec
  module Rails
    module Runner
      class ModelEvalContext < Spec::Rails::Runner::EvalContext
      end
      class ModelContext < Spec::Rails::Runner::Context
        def before_context_eval
          inherit_context_eval_module_from Spec::Rails::Runner::ModelEvalContext
          @context_eval_module.init_global_fixtures
        end
      end
    end
  end
end
