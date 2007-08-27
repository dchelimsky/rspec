module Spec
  module Story
    class SimpleStep
      def initialize(name, &block)
        @name = name
        @mod = Module.new do
          define_method name, &block
        end
      end
      
      def perform(instance, *args)
        instance.extend(@mod)
        instance.__send__(@name, *args)
      end
    end
  end
end
