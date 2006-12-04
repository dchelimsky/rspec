module Spec
  module Rails
    class ModelEvalContext < Spec::Rails::EvalContext
    end
    class ModelContext < Spec::Rails::Context
      def before_context_eval
        inherit Spec::Rails::ModelEvalContext
      end
    end
  end
end

