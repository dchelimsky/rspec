module Spec
  module Example
    # The superclass for all regular RSpec examples.
    class ExampleGroup
      extend Spec::Example::ExampleGroupMethods
      include Spec::Example::ExampleMethods

      def initialize(example, instance_variables={}) #:nodoc:
        instance_variables.each do |variable_name, value|
          instance_variable_set variable_name, value
        end
        @_example = example
      end
    end
  end
end

Spec::ExampleGroup = Spec::Example::ExampleGroup
