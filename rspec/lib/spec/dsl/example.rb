module Spec
  module DSL
    class Example
      remove_method :default_test if respond_to?(:default_test)
      include ExampleModule
    end
  end
end
