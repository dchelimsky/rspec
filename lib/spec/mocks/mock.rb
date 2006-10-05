module Spec
  module Mocks
    module MockInstanceMethods
      def should_receive(sym, &block)
        __mock_handler.add MessageExpectation, caller(1)[0], sym, &block
      end

      def should_not_receive(sym, &block)
        __mock_handler.add NegativeMessageExpectation, caller(1)[0], sym, &block
      end
      
      def __verify
        __mock_handler.verify
      end
      
      def stub!(sym)
        should_receive(sym).any_number_of_times
      end

      def method_missing(sym, *args, &block)
        begin
          return self if __mock_handler.null_object?
          super(sym, *args, &block)
        rescue NoMethodError
          __mock_handler.handle_no_method_error sym, *args
        end
      end
      
      private
      def __mock_handler
        @mock_handler ||= MockHandler.new(self, @name, @options)
      end
    end

    class Mock
      include MockInstanceMethods

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