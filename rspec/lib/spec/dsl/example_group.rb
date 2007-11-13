module Spec
  module DSL
    # The superclass for all regular RSpec examples.
    # See also Test::Unit::TestCase::ExampleGroup
    class ExampleGroup
      extend ExampleGroupMethods
      include ExampleMethods
    end
  end
end

Spec::ExampleGroup = Spec::DSL::ExampleGroup
