module Spec
  module Rails
    module DSL
      # Model examples live in $RAILS_ROOT/spec/models/.
      #
      # Model examples use Spec::Rails::DSL::ModelExample, which
      # provides support for fixtures and some custom expectations via extensions
      # to ActiveRecord::Base.
      class ModelExample < RailsExample
        Spec::DSL::ExampleGroupFactory.register(:model, self)
      end
    end
  end
end
