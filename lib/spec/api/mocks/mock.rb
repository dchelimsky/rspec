module Spec
  module Api
    class Mock
      # Remove all methods so they can be mocked too
      (public_instance_methods - ['__id__', '__send__', 'nil?']).each do |m|
        undef_method m
      end

      # Creates a new mock with a +name+ (that will be used in error messages only)
      # Options:
      # * <tt>:null_object</tt> - if true, the mock object acts as a forgiving null object allowing any message to be sent to it.
      def initialize(name, options={})
        @name = name
        @options = DEFAULT_OPTIONS.dup.merge(options)
        @expectations = []
        @expectation_ordering = OrderGroup.new
      end
      
      def should_receive(sym, &block)
        add MessageExpectation, caller(1)[0], sym, &block
      end
      
      def should_not_receive(sym, &block)
        add NegativeMessageExpectation, caller(1)[0], sym, &block
      end
      
      def add(expectation_class, expected_from, sym, &block)
        expectation = expectation_class.send(:new, @name, @expectation_ordering, expected_from, sym, block_given? ? block : nil)
        @expectations << expectation
        expectation
      end

      def __verify #:nodoc:
        @expectations.each do |expectation|
          expectation.verify_messages_received
        end
      end

      def method_missing(sym, *args, &block)
        if expectation = find_matching_expectation(sym, *args)
          expectation.invoke(args, block)
        else
          begin
            # act as null object if method is missing and we ignore them. return value too!
            @options[:null_object] ? self : super(sym, *args, &block)
          rescue NoMethodError
            arg_message = args.collect{|arg| "<#{arg}:#{arg.class.name}>"}.join(", ")
            Kernel::raise Spec::Api::MockExpectationError, "Mock '#{@name}' received unexpected message '#{sym}' with [#{arg_message}]"
          end
        end
      end

    private

      DEFAULT_OPTIONS = {
        :null_object => false
      }
      
      def find_matching_expectation(sym, *args)
        expectation = @expectations.find {|expectation| expectation.matches(sym, args)}
      end

    end

  end
end