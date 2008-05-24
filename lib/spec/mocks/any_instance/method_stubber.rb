module Spec
  module Mocks
    module AnyInstance
      class MethodStubber

        def initialize(target, message)
          @target = target
          @message = message
          @munged_sym = "__rspec_proxy_any_instance_#{message}".to_sym
        end

        def add_stub
          add_stub_with_value nil
        end

        def and_return(value)
          add_stub_with_value value
        end

        def and_raise(*raise_params)
          add_stub_with_error *raise_params
        end

        def reset!
          swap_methods @munged_sym, @message
          @target.send(:remove_method, @munged_sym) if @target.method_defined?(@munged_sym)
        end
        alias_method :rspec_reset, :reset!
        
        def verified?
          @verified
        end
        
        def rspec_verify
          @verified = true
        end
        
        private
        def define_stub(&impl)
          store_current_instance_method do |message|
            @target.send(:define_method, message, &impl)
          end
        end
        
        def add_stub_with_value(value)
          define_stub { value }
        end

        def add_stub_with_error(*raise_params)
          define_stub { raise *raise_params }
        end

        def store_current_instance_method(&block)
          swap_methods @message, @munged_sym, &block
        end

        def swap_methods(first, second)
          @target.class_eval do
            alias_method second, first if method_defined?(first)
          end
          yield first if block_given?
        end

      end
    end
  end
end
