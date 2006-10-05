module Spec
  module Mocks
    class MockHandler
      def initialize(target, name, options={})
        @target = target
        @name = name
        @expectation_ordering = OrderGroup.new
        @expectations = []
        @proxied_methods = []
        @options = options ? DEFAULT_OPTIONS.dup.merge(options) : DEFAULT_OPTIONS
      end
      
      def message_intro
        @name ? "Mock '#{@name}'" : @target.to_s
      end

      def handle_no_method_error sym, *args
        arg_message = args.collect{|arg| "<#{arg}:#{arg.class.name}>"}.join(", ")
        Kernel::raise Spec::Mocks::MockExpectationError, "#{message_intro} received unexpected message '#{sym}' with [#{arg_message}]"
      end

      def add(expectation_class, expected_from, sym, &block)
        Runner::Specification.add_listener(self)
        define_expected_method(sym)
        expectation = expectation_class.send(:new, message_intro, @expectation_ordering, expected_from, sym, block_given? ? block : nil)
        @expectations << expectation
        expectation
      end
      
      def spec_finished spec
        verify
      end

      def define_expected_method(sym)
        if @target.respond_to? sym
          metaclass_eval %-
            alias_method :#{__pre_proxied_method_name(sym)}, :#{sym}
          -
          @proxied_methods << sym
        end

        metaclass_eval %{
          def #{sym}(*args, &block)
            __mock_handler.message_received :#{sym}, *args, &block # ?
          end
        }
      end

      def __pre_proxied_method_name method_name
        "original_#{method_name.to_s.delete('!')}_before_proxy"
      end

      def verify #:nodoc:
        begin
          verify_expectations
        ensure
          reset
        end
      end
      
      def reset
        clear_expectations
        reset_proxied_methods
        clear_proxied_methods
      end
      
      def verify_expectations
        @expectations.each do |expectation|
          expectation.verify_messages_received
        end
      end

      def reset_proxied_methods
        @proxied_methods.each do |method_name|
          if @target.respond_to? __pre_proxied_method_name(method_name)
            metaclass_eval %-
              alias_method :#{method_name}, :#{__pre_proxied_method_name(method_name)}
              remove_method :#{__pre_proxied_method_name(method_name)}
            -
          end  
        end  
      end  

      def clear_expectations #:nodoc:
        @expectations.clear
      end
      
      def clear_proxied_methods #:nodoc:
        @proxied_methods.clear
      end

      def metaclass_eval str
        (class << @target; self; end).class_eval str
      end

      def find_matching_expectation(sym, *args)
        @expectations.find {|expectation| expectation.matches(sym, args)}
      end
      
      def find_almost_matching_expectation(sym, *args)
        @expectations.find {|expectation| expectation.matches_name_but_not_args(sym, args)}
      end
      
      def has_negative_expectation?(sym)
        @expectations.find {|expectation| expectation.negative_expectation_for?(sym)}
      end
      
      def message_received(sym, *args, &block)
        if expectation = find_matching_expectation(sym, *args)
          expectation.invoke(args, block)
        elsif expectation = find_almost_matching_expectation(sym, *args)
          handle_no_method_error sym, *args unless has_negative_expectation?(sym)
        else
          @target.send :method_missing, sym, *args, &block
        end
      end

      DEFAULT_OPTIONS = {
        :null_object => false
      }
      
      def null_object?
        @options[:null_object]
      end

    end
  end
end