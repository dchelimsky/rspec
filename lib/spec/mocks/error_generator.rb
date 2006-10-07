module Spec
  module Mocks
    class ErrorGenerator
      attr_reader :target, :name
      def initialize target, name
        @target = target
        @name = name
      end

      def raise_unexpected_message_error sym, *args
        __raise "#{intro} received unexpected message '#{sym}' with [#{arg_message(*args)}]"
      end
      
      def raise_expectation_error sym, count_message, received_count
        __raise "#{intro} expected '#{sym}' #{count_message}, but received it #{received_count} times"
      end
      
      def raise_out_of_order_error sym
        __raise "#{intro} received '#{sym}' out of order"
      end
      
      def raise_violated_error detail
        __raise "Call expectation violated with: " + detail
      end
      
      def raise_missing_block_error
        __raise "Expected block to be passed"
      end
      
      def raise_wrong_arity_error arity
        __raise "Wrong arity of passed block. Expected #{arity}"
      end
      
      def intro
        @name ? "Mock '#{@name}'" : @target.to_s
      end
      
      private
      def __raise message
        Kernel::raise Spec::Mocks::MockExpectationError, message
      end
      
      def arg_message *args
        args.collect{|arg| "<#{arg}:#{arg.class.name}>"}.join(", ")
      end
      

    end
  end
end