module Spec
  module Rails
    module DSL
      class FunctionalBehaviour < RailsBehaviour
        def example_superclass # :nodoc:
          FunctionalExample
        end
      end
    end
  end
end
