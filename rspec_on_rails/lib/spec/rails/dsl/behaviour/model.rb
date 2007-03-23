module Spec
  module Rails
    module DSL
      # Model examples live in $RAILS_ROOT/spec/models/.
      #
      # Model examples use Spec::Rails::DSL::ModelBehaviour, which
      # provides support for fixtures and some custom expectations via extensions
      # to ActiveRecord::Base.
      class ModelBehaviour < Spec::DSL::Behaviour
        def before_eval # :nodoc:
          inherit Spec::Rails::DSL::EvalContext
          configure
        end
      end
    end
  end
end
