module Spec
  module MethodProxy
    class MethodProxy
      def initialize target, method_name, block
        @method_name = method_name
        @replacement_method = block
        @target = target

        if target.respond_to? method_name
          target_metaclass_eval %-
            alias_method :#{__pre_proxied_method_name(method_name)}, :#{method_name}
          -
        end

        target_metaclass_eval %-
          def #{method_name}(*args, &block)
            __method_proxy_space.proxied_methods[:#{method_name}].call(*args, &block)
          end
        -
      end
      
      def call(*args, &block)
        args << block if block
        @replacement_method.call(*args)
      end
      
      def reset!
        if @target.respond_to? __pre_proxied_method_name(@method_name)
          target_metaclass_eval %-
            alias_method :#{@method_name}, :#{__pre_proxied_method_name(@method_name)}
            remove_method :#{__pre_proxied_method_name(@method_name)}
          -
        else
          target_metaclass_eval %-
            remove_method :#{@method_name}
          -
        end  
      end
      
      private
      def target_metaclass_eval str
        (class << @target; self; end).class_eval str
      end
      
      def __pre_proxied_method_name method_name
        "original_#{method_name}_before_proxy"
      end
      
    end
  end
end
