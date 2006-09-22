module Spec
  module Stubs
    class StubSpace
      attr_reader :registry

      def initialize
        @registry = create_registry
      end

      def create_registry
        registry = StubRegistry.new
        registry.space = self
        registry
      end

      def create_stub(target, name="")
        stub = Stub.new(target, name)
        stub.space = self
        stub
      end

      def create_method(target, method_name)
        method = StubMethod.new(target, method_name)
        method.space = self
        method
      end
    end
  end
end
