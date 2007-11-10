module Spec
  module DSL
    class ExampleGroup < ::Test::Unit::TestCase
      remove_method :default_test if respond_to?(:default_test)

      class << self
        include Behaviour
      end

      include ExampleGroupMethods
    end
  end
end

Spec::ExampleGroup = Spec::DSL::ExampleGroup
