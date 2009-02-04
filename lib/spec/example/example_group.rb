module Spec
  module Example
    # Base class for customized example groups. Use this if you
    # want to make a custom example group.
    class ExampleGroup
      extend Spec::Example::ExampleGroupMethods
      include Spec::Example::ExampleMethods

      def initialize(description, options={}, &implementation)
        @_options = options
        @_defined_description = description
        @_implementation = ensure_implementation(implementation)
        @_backtrace = caller
      end
      
    end
  end
end

