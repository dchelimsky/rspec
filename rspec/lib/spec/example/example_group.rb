module Spec
  module Example
    # The superclass for all regular RSpec examples.
    class ExampleGroup
      extend Spec::Example::ExampleGroupMethods
      include Spec::Example::ExampleMethods

      def initialize(example, instance_variables={}) #:nodoc:
        set_instance_variables_from_hash instance_variables
        @_example = example
      end
    end
  end
end

Spec::ExampleGroup = Spec::Example::ExampleGroup
