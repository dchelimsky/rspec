module Spec
  module Mocks

    # Represents the expection of the reception of a message
    class MessageExpectation
      
      attr_reader :sym
      
      def initialize(error_generator, expectation_ordering, expected_from, sym, method_block, expected_received_count=1)
        @error_generator = error_generator
        @expected_from = expected_from
        @sym = sym
        @method_block = method_block
        @return_block = lambda {}
        @received_count = 0
        @expected_received_count = expected_received_count
        @args_expectation = ArgumentExpectation.new([:any_args])
        @consecutive = false
        @exception_to_raise = nil
        @symbol_to_throw = nil
        @order_group = expectation_ordering
        @at_least = nil
        @at_most = nil
        @args_to_yield = nil
      end
  
      def matches(sym, args)
        @sym == sym and @args_expectation.check_args(args)
      end
      
      def matches_name_but_not_args(sym, args)
        @sym == sym and not @args_expectation.check_args(args)
      end
       
      # This method is called at the end of a spec, after teardown.
      def verify_messages_received
        # TODO: this doesn't provide good enough error messages to fix the error.
        # Error msg should tell exactly what went wrong. (AH).
        
        return if @expected_received_count == :any
        return if (@at_least) && (@received_count >= @expected_received_count)
        return if (@at_most) && (@received_count <= @expected_received_count)
        return if @expected_received_count == @received_count
    
        begin
          @error_generator.raise_expectation_error @sym, @expected_received_count, @received_count
        rescue => error
          error.backtrace.insert(0, @expected_from)
          Kernel::raise error
        end
      end

      # This method is called when a method is invoked on a mock
      def invoke(args, block)
        @order_group.handle_order_constraint self

        begin
          Kernel::raise @exception_to_raise.new unless @exception_to_raise.nil?
          Kernel::throw @symbol_to_throw unless @symbol_to_throw.nil?

          if !@method_block.nil?
            return invoke_method_block(args)
          elsif !@args_to_yield.nil?
            return invoke_with_yield(block)
          else
            return invoke_return_block(args, block)
          end
        ensure
          @received_count += 1
        end
      end

      def invoke_method_block(args)
        begin
          @method_block.call(*args)
        rescue Spec::Expectations::ExpectationNotMetError => detail
          @error_generator.raise_violated_error detail
        end
      end
      
      def invoke_with_yield(block)
        if block.nil?
          @error_generator.raise_missing_block_error
        end
        if @args_to_yield.length != block.arity
          @error_generator.raise_wrong_arity_error @args_to_yield.size
        end
        block.call(*@args_to_yield)
      end

      def invoke_return_block(args, block)
        args << block unless block.nil?
        value = @return_block.call(*args)
    
        if @consecutive
          index = [@received_count, value.size-1].min
          value[index]
        else
          value
        end
      end

      def with(*args)
        @args_expectation = ArgumentExpectation.new(args)
        self
      end
      
      def exactly(n)
        set_expected_received_count :exactly, n
        self
      end
      
      def at_least(n)
        set_expected_received_count :at_least, n
        self
      end
      
      def at_most(n)
        set_expected_received_count :at_most, n
        self
      end
      
      def set_expected_received_count relativity, n
        @at_least = (relativity == :at_least)
        @at_most = (relativity == :at_most)
        @expected_received_count = 1 if n == :once
        @expected_received_count = 2 if n == :twice
        @expected_received_count = n if n.kind_of? Numeric
      end

      def times
        #pure sugar
        self
      end
  
      def any_number_of_times
        @expected_received_count = :any
        self
      end
  
      #TODO - replace this w/ not syntax in mock
      def never
        @expected_received_count = 0
        self
      end
  
      def once
        @expected_received_count = 1
        self
      end
  
      def twice
        @expected_received_count = 2
        self
      end
  
      def and_return(value=nil, &return_block)
        Kernel::raise AmbiguousReturnError unless @method_block.nil?
        @consecutive = value.instance_of? Array
        @return_block = block_given? ? return_block : lambda { value }
      end
      
      def and_raise(exception=Exception)
        @exception_to_raise = exception
      end
      
      def and_throw(symbol)
        @symbol_to_throw = symbol
      end
      
      def and_yield(*args)
        @args_to_yield = args
      end
  
      def ordered
        @order_group.register(self)
        @ordered = true
        self
      end
      
      def negative_expectation_for? sym
        return false
      end
    end
    
    class NegativeMessageExpectation < MessageExpectation
      def initialize(message, expectation_ordering, expected_from, sym, method_block)
        super message, expectation_ordering, expected_from, sym, method_block, 0
      end
      
      def negative_expectation_for? sym
        return @sym == sym
      end
    end
  end
end