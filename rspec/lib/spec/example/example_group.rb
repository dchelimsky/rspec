module Spec
  module Example
    # The superclass for all regular RSpec examples.
    # See also Test::Unit::TestCase::ExampleGroup
    class ExampleGroup
      extend Spec::Example::ExampleGroupMethods
      include Spec::Example::ExampleMethods

      def initialize(example) #:nodoc:
        @_example = example
      end
    end
  end
end

Spec::ExampleGroup = Spec::Example::ExampleGroup
