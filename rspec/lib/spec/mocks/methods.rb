module Spec
  module Mocks
    # == Mock and Stub Methods
    #
    # This Module gets mixed in to the Mock class as well as Object. This means that you
    # can create anonymous mock objects and stubs, as well as setting stub values or
    # mock expectations on your real objects and classes.
    #
    # == Creating a Mock
    #
    # You can create a mock in any specification (or setup) using:
    #
    #   mock(name)
    #   mock(name, options)
    #
    # For example, if you wanted to create a mock named "person" that would act
    # as a null object, you would do this:
    #
    #   mock("person", :null_object => true)
    #
    # == Creating a Stub
    #
    # You can create a stub in any specification (or setup) using:
    #
    #   stub(name, stub_methods_and_values_hash)
    #
    # For example, if you wanted to create an object that always returns
    # "More?!?!?!" to "please_sir_may_i_have_some_more" you would do this:
    #
    #   stub("Mr Sykes", :please_sir_may_i_have_some_more => "More?!?!?!")
    #
    module Methods
      def should_receive(sym, opts={}, &block)
        __mock_handler.add_message_expectation(opts[:expected_from] || caller(1)[0], sym, opts, &block)
      end

      def should_not_receive(sym, &block)
        __mock_handler.add_negative_message_expectation(caller(1)[0], sym, &block)
      end
      
      def stub!(sym)
        __mock_handler.add_stub(caller(1)[0], sym)
      end
      
      def received_message?(sym, *args, &block) #:nodoc:
        __mock_handler.received_message?(sym, *args, &block)
      end
      
      def __verify #:nodoc:
        __mock_handler.verify
      end

      def __reset_mock #:nodoc:
        __mock_handler.reset
      end

      def method_missing(sym, *args, &block) #:nodoc:
        __mock_handler.instance_eval {@messages_received << [sym, args, block]}
        super(sym, *args, &block)
      end
      
      private

      def __mock_handler
        @mock_handler ||= MockHandler.new(self, @name, @options)
      end
    end
  end
end