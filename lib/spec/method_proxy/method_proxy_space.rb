module Spec
  module MethodProxy
    class MethodProxySpace
      module ClassMethods
        def instance
          @instance ||= new
        end
      end
      extend ClassMethods

      def initialize
        @proxied_objects = []
      end

      def proxied_methods
        @proxied_methods ||= Hash.new
      end

      def create_proxy(target, method_name, block)
        @proxied_objects << target
        MethodProxy.new target, method_name, block
      end

      def clear!
        @proxied_objects.each do |obj|
          obj.reset_proxied_methods!
        end
      end
      
      def reset_proxied_methods!
        proxied_methods.each { |method_name, proxy| proxy.reset! }
        proxied_methods.clear
      end
      
    end
  end
end