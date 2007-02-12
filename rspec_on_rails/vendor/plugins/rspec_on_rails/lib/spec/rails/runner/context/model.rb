module Spec
  module Rails
    module Runner
      class ModelEvalContext < Spec::Rails::Runner::EvalContext
      end
      # Model Specs go in spec/models and provide access to
      # fixtures along with some custom expectations via extensions
      # to ActiveRecord::Base.
      class ModelContext < Spec::Rails::Runner::Context
        def before_context_eval # :nodoc:
          inherit_context_eval_module_from Spec::Rails::Runner::ModelEvalContext
          @context_eval_module.init_global_fixtures
        end
      end
    end
  end
end
