module Spec
  module Rails
    module Example
      # Model examples live in $RAILS_ROOT/spec/models/.
      #
      # Model examples use Spec::Rails::Example::ModelExample, which
      # provides support for fixtures and some custom expectations via extensions
      # to ActiveRecord::Base.
      class ModelExample < RailsExample
        Spec::Example::ExampleGroupFactory.register(:model, self)
      end
    end
  end
end
