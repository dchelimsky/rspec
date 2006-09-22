module Spec
  module Stubs
    class StubRegistry
      attr_writer :space

      def initialize
        @map = Hash.new do |hash, key|
          hash[key] = {}
        end
      end

      def [](target, method_name)
        @map[target][method_name]
      end

      def []=(target, method_name, value)
        @map[target][method_name] = value
      end

      def invoke(target, method_name, args, &block)
        args << block if block
        self[target, method_name].call(*args)
      end

      def clear!
        @map.values.each do |method_hash|
          method_hash.values.each do |method|
            method.reset!
          end
        end
        @map.clear
      end
    end
  end
end
