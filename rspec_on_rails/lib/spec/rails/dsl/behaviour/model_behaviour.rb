module Spec
  module Rails
    module DSL
      # Model examples live in $RAILS_ROOT/spec/models/.
      #
      # Model examples use Spec::Rails::DSL::ModelBehaviour, which
      # provides support for fixtures and some custom expectations via extensions
      # to ActiveRecord::Base.
      class ModelBehaviour < RailsBehaviour
        def before_eval # :nodoc:
          super
          prepend_before {@test_case.setup}
          append_after {@test_case.teardown}
          configure
        end

        def example_class
          ModelExample
        end

        Spec::DSL::BehaviourFactory.add_behaviour_class(:model, self)
      end
    end
  end
end
