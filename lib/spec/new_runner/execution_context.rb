module Spec
  module Runner
    class ExecutionContext
      def initialize(spec)
        @spec = spec
      end
      
      def mock(name)
        ::Mock.new(name)
      end
    end
  end
end