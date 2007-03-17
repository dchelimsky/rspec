module Spec
  module Rails
    module Runner
      class ModelEvalContext < Spec::Rails::Runner::EvalContext
      end
      # Model Specs live in $RAILS_ROOT/spec/models/.
      #
      # Model Specs use Spec::Rails::Runner::ModelContext, which
      # provides support for fixtures and some custom expectations via extensions
      # to ActiveRecord::Base.
      class ModelContext < Spec::Rails::Runner::Context
        def before_eval # :nodoc:
          inherit Spec::Rails::Runner::ModelEvalContext
          init_global_fixtures
        end
      end
    end
  end
end
