module Spec
  module Mocks
    class Mock
      include MockMethods

      # Creates a new mock with a +name+ (that will be used in error messages only)
      # Options:
      # * <tt>:null_object</tt> - if true, the mock object acts as a forgiving null object allowing any message to be sent to it.
      def initialize(name, options={})
        @name = name
        @options = options
      end
    end
  end
end