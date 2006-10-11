module Spec
  module Mocks
    class ErrorGenerator
      def initialize target, name
        @target = target
        @name = name
      end

      def raise_unexpected_message_error sym, *args
        __raise " #{intro} received unexpected message :#{sym}#{arg_message(*args)}"
      end
      
      def raise_expectation_error sym, expected_received_count, actual_received_count, *args
        __raise " #{intro} expected :#{sym}#{arg_message(*args)} #{make_count_message(expected_received_count)}, but received it #{actual_received_count} times"
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
      
      private
      def intro
        @name ? "Mock '#{@name}'" : @target.to_s
      end
      
      def __raise message
        Kernel::raise Spec::Mocks::MockExpectationError, message
      end
      
      def arg_message *args
        return "" if [:any_args] == args
        " with [" + args.collect do |arg|
          if arg.is_a? String
            "'#{arg}'"
          elsif arg.is_a? Symbol
            ":#{arg}"
          elsif arg.is_a? Fixnum
            "#{arg}"
          else
            "<#{arg}:#{arg.class.name}>"
          end
        end.join(", ") + "]"
      end
      
      def make_count_message(count)
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