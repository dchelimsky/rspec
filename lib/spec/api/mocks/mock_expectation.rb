require File.dirname(__FILE__) + '/argument_expectation'

module Spec
  module Api

    # Represents the expection of the reception of a message
    class MessageExpectation

      def initialize(mock_name, expected_from, sym, block)
        @mock_name = mock_name
        @expected_from = expected_from
        @sym = sym
        @method_block = block
        @block = proc {}
        @received_count = 0
        @expected_received_count = 1
        @args_expectation = ArgumentExpectation.new([:any_args])
        @consecutive = false
        @exception_to_raise = nil
        @symbol_to_throw = nil
        @any_seen = false
        @at_seen = false
        @and_seen = false
        @identifier = nil
        @after = nil
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
    
        expected_signature = nil
        if @expected_params.nil?
          expected_signature = @sym
        else
          params = @expected_params.collect{|param| "<#{param}:#{param.class.name}>"}.join(", ")
          expected_signature = "#{@sym}(#{params})"
        end
    
        count_message = make_count_message(@expected_received_count)

        message = "Mock '#{@mock_name}' expected #{expected_signature} #{count_message}, but received it #{@received_count} times"
        begin
          Kernel::raise Spec::Api::MockExpectationError, message
        rescue => error
          error.backtrace.insert(0, @expected_from)
          Kernel::raise error
        end
      end

      def order_ok(history)
        return true if @after.nil?
        return history.include? @after
      end

      def handle_order_constraint(history)
        Kernel::raise(Spec::Api::MockExpectationError, "Call made out of order") unless order_ok(history)
        history << @identifier unless @identifier.nil?
      end
      
      # This method is called when a method is invoked on a mock
      def verify_message(history, args, block)
        
        handle_order_constraint(history)
        
        unless @method_block.nil?
          begin
            result = @method_block.call(*args)
          rescue Spec::Api::ExpectationNotMetError => detail
            Kernel::raise Spec::Api::MockExpectationError, "Call expectation violated with: " + $!
          end
          @received_count += 1
          return result
        end
    
        Kernel::raise @exception_to_raise.new unless @exception_to_raise.nil?
        Kernel::throw @symbol_to_throw unless @symbol_to_throw.nil?
        unless @args_to_yield.nil?
          if block.nil?
            Kernel::raise Spec::Api::MockExpectationError, "Expected block to be passed"
          end
          if @args_to_yield.length != block.arity
            Kernel::raise Spec::Api::MockExpectationError, "Wrong arity of passed block. Expected #{@args_to_yield.size}"
          end
          block.call @args_to_yield
        end

        args << block unless block.nil?
        @received_count += 1        
        value = @block.call(*args)
    
        return value unless @consecutive
    
        value[[@received_count, value.size].min - 1]
      end

      def with(*args)
        @args_expectation = ArgumentExpectation.new(args)
        self
      end
      
      def at
        @at_seen = true
        self
      end
      
      def exactly(n)
        @expected_received_count = n
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

      def return(value=nil,&block)
        return self unless @and_seen
        @and_seen = false
        @consecutive = value.instance_of? Array
        @block = block_given? ? block : proc { value }
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
      
      def id(anId)
        @identifier = anId
        self
      end
      
      def after(anId)
        @after = anId
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