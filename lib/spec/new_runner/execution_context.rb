module Spec
  module Runner
    class ExecutionContext
      def initialize(spec)
        @spec = spec
      end
      
      def mock(name)
        mock = ::Mock.new(name)
        @spec.add_mock(mock)
        mock
      end
    end
  end
end