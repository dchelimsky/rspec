module Spec
  module Mocks
    class Mock
      include Methods

      # Creates a new mock with a +name+ (that will be used in error messages only)
      # == Options:
      # * <tt>:null_object</tt> - if true, the mock object acts as a forgiving null object allowing any message to be sent to it.
      def initialize(name, options={})
        @name = name
        @options = options
      end
      
      # This allows for comparing the mock to other objects that proxy
      #  such as ActiveRecords belongs_to proxy objects
      #  By making the other object run the comparison, we're sure the call gets delegated to the proxy target
      # This is an unfortunate side effect from ActiveRecord, but this should be safe unless the RHS redefines == in a nonsensical manner
      def ==(other)
        other == __mock_proxy
      end

      def method_missing(sym, *args, &block)
        __mock_proxy.instance_eval {@messages_received << [sym, args, block]}
        begin
          return self if __mock_proxy.null_object?
          super(sym, *args, &block)
        rescue NameError
          __mock_proxy.raise_unexpected_message_error sym, *args
        end
      end
      
      def inspect
        "#<#{self.class}:#{sprintf '0x%x', self.object_id} @name=#{@name.inspect}>"
      end
    end
  end
end
