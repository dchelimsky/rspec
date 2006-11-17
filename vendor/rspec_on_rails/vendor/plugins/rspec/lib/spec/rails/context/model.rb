module Spec
  module Rails
    class ModelContext < Rails::Context
      def before_context_eval
        inherit Spec::Rails::EvalContext
      end
    end
  end
end

