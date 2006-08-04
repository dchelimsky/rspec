module Spec
  module Api

    # Represents the expection of the reception of a message
    class MessageExpectation
    
      def initialize(mock_name, expectation_ordering, expected_from, sym, method_block)
        @mock_name = mock_name
        @expected_from = expected_from
        @sym = sym
        @method_block = method_block
        @return_block = lambda {}
        @received_count = 0
        @expected_received_count = 1
        @args_expectation = ArgumentExpectation.new([:any_args])
        @consecutive = false
        @exception_to_raise = nil
        @symbol_to_throw = nil
        @any_seen = false
        @at_seen = false
        @and_seen = false
        @ordering = expectation_ordering
        @ordered = false
      end
  
      def matches(sym, args)
        @sym == sym and @args_expectation.check_args(args)
      end
       
      def make_count_message(count)
        return "at least #{pretty_print(count.abs)}" if count < 0
        return pretty_print(count) if count > 0
        return "never"
      end
      
      def pretty_print(count)
        return "once" if count == 1
        return "twice" if count == 2
        return "#{count} times"
      end
      
      # This method is called at the end of a spec, after teardown.
      def verify_messages_received
        # TODO: this doesn't provide good enough error messages to fix the error.
        # Error msg should tell exactly what went wrong. (AH).
        
        return if @expected_received_count == :any
        return if (@expected_received_count < 0) && (@received_count >= @expected_received_count.abs)
        return if @expected_received_count == @received_count
    
        count_message = make_count_message(@expected_received_count)

        message = "Mock '#{@mock_name}' expected '#{@sym}' #{count_message}, but received it #{@received_count} times"
        begin
          Kernel::raise(Spec::Api::MockExpectationError, message)
        rescue => error
          error.backtrace.insert(0, @expected_from)
          Kernel::raise error
        end
      end

      def handle_order_constraint
        return unless @ordered
        return @ordering.consume(@self) if @ordering.ready_for?(self)
        message = "Mock '#{@mock_name}' received '#{@sym}' out of order"
        Kernel::raise(Spec::Api::MockExpectationError, message) 
      end
      
      # This method is called when a method is invoked on a mock
      def invoke(args, block)
        
        handle_order_constraint

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
        rescue Spec::Api::ExpectationNotMetError => detail
          Kernel::raise Spec::Api::MockExpectationError, "Call expectation violated with: " + detail
        end
      end
      
      def invoke_with_yield(block)
        if block.nil?
          Kernel::raise Spec::Api::MockExpectationError, "Expected block to be passed"
        end
        if @args_to_yield.length != block.arity
          Kernel::raise Spec::Api::MockExpectationError, "Wrong arity of passed block. Expected #{@args_to_yield.size}"
        end
        block.call *@args_to_yield
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
        @expected_received_count = n
        self
      end
      
      def at
        @at_seen = true
        self
      end
      
      def least(arg)
        if @at_seen
          @expected_received_count = -1 if arg == :once
          @expected_received_count = -2 if arg == :twice
          @expected_received_count = -arg if arg.kind_of? Numeric
        end
        @at_seen = false
        self
      end

      def any
        @any_seen = true
        self
      end
      
      def number
        @number_seen = @any_seen
        @any_seen = false
        self
      end
      
      def of
        @of_seen = @number_seen
        @number_seen = false
        self
      end
      
      def times
        @expected_received_count = :any if @of_seen
        @of_seen = false
        self
      end
  
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
  
      def and
        @and_seen = true
        self
      end

      def return(value=nil, &return_block)
        Kernel::raise AmbiguousReturnError unless @method_block.nil?
        return self unless @and_seen
        @and_seen = false
        @consecutive = value.instance_of? Array
        @return_block = block_given? ? return_block : lambda { value }
      end
      
      def raise(exception=Exception)
        return self unless @and_seen
        @and_seen = false
        @exception_to_raise = exception
      end
      
      def throw(symbol)
        return self unless @and_seen
        @and_seen = false
        @symbol_to_throw = symbol
      end
      
      def ordered
        @ordering.register(self)
        @ordered = true
        self
      end
      
      def yield(*args)
        return self unless @and_seen
        @and_seen = false
        @args_to_yield = args
      end
  
    end
  end
end