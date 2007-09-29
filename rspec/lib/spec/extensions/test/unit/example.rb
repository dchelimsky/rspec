module Spec
  module Test
    module Unit
      class Example < ::Test::Unit::TestCase
        remove_method :default_test if respond_to?(:default_test)
        include ::Spec::DSL::ExampleModule

        def initialize(definition)
          @_result = ::Test::Unit::TestResult.new
          super
        end
      end      
    end
  end
end
