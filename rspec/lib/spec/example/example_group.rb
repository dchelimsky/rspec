module Spec
  module Example
    # The superclass for all regular RSpec examples.
    # See also Test::Unit::TestCase::ExampleGroup
    class ExampleGroup < Test::Unit::TestCase
      # TODO: inherit from Object
      remove_method :default_test if respond_to?(:default_test)
      extend Spec::Example::ExampleGroupMethods
      include Spec::Example::ExampleMethods

      def initialize(example) #:nodoc:
        @_example = example
        @_result = ::Test::Unit::TestResult.new
      end
    end
  end
end

Spec::ExampleGroup = Spec::Example::ExampleGroup
