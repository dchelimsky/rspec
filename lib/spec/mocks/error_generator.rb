module Spec
  module Mocks
    class ErrorGenerator
      def initialize target, name
        @target = target
        @name = name
      end

      def raise_unexpected_message_error sym, *args
        __raise "#{intro} received unexpected message :#{sym}#{arg_message(*args)}"
      end
      
      def raise_expectation_error sym, expected_received_count, actual_received_count, *args
        __raise "#{intro} expected :#{sym}#{arg_message(*args)} #{count_message(expected_received_count)}, but received it #{count_message(actual_received_count)}"
      end
      
      def raise_out_of_order_error sym
        __raise "#{intro} received :#{sym} out of order"
      end
      
      def raise_block_failed_error sym, detail
        __raise "#{intro} received :#{sym} but passed block failed with: #{detail}"
      end
      
      def raise_missing_block_error args_to_yield
        __raise "#{intro} asked to yield |#{arg_list(*args_to_yield)}| but no block was passed"
      end
      
      def raise_wrong_arity_error args_to_yield, arity
        __raise "#{intro} yielded |#{arg_list(*args_to_yield)}| to block with arity of #{arity}"
      end
      
      private
      def intro
        @name ? "Mock '#{@name}'" : @target.to_s
      end
      
      def __raise message
        Kernel::raise Spec::Mocks::MockExpectationError, message
      end
      
      def arg_message *args
        return "" if [:any_args] == args
        return if args.empty?
        " with [" + arg_list(*args) + "]"
      end

      def arg_list(*args)
        args.collect{|arg| arg.inspect}.join(", ")
      end
      
      def count_message(count)
        return "at least #{pretty_print(count.abs)}" if count < 0
        return pretty_print(count)
      end

      def pretty_print(count)
        return "once" if count == 1
        return "twice" if count == 2
        return "#{count} times"
      end

    end
  end
end