module Spec
  module DSL
    class ExampleGroup < ::Test::Unit::TestCase
      remove_method :default_test if respond_to?(:default_test)
      extend ExampleGroupMethods
      include ExampleMethods
    end
  end
end

Spec::ExampleGroup = Spec::DSL::ExampleGroup
